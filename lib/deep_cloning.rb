require 'active_record'

module DeepCloning
  # This is the main class responsible to evaluate the equations
  class Clone
    VERSION = '0.1.4'.freeze
    def initialize(root, opts = { except: [], save_root: true })
      @root = root
      @opts = opts
      @opts[:source] = []
      @must_ignore = []
    end

    def replicate
      ActiveRecord::Base.transaction do
        # the block can be used to change the fields and fix eventual validation problems
        leafs_statuses = { "#{@root.class.name}_#{@root.id}" => true }
        if @opts[:save_root]
          clone = @root.dup
          yield(@root, clone, :before_save) if block_given?
          clone.save if clone.new_record? # avoid save again if saved on block
          yield(@root, clone, :after_save) if block_given?
          raise "#{clone.class} - #{clone.errors.full_messages.join(', ')}" if clone.errors.any?
          @opts[clone.class.name] = { @root.id => clone }
        end
        leafs(@root).each do |cell|
         @opts[:source] << cell if block_given? and not yield(cell, cell, :skip?)
        end

        while @opts[:source].any?
          @cell = @opts[:source].detect do |n|
            n = yield(n, n, :prepare) if block_given?
            walk?(n)
          end
          unless @cell
            ap @opts[:source].map { |s| "#{s.id} - #{s.class.name}" }
            raise "Cannot duplicate the Hierarchy. You must ignore: #{@must_ignore.join(', ')}"
          end
          @opts[:source] -= [@cell]

          @opts[@cell.class.name] = {} unless @opts[@cell.class.name]
          next if @opts[@cell.class.name][@cell.id] # already cloned?

          unless @cell.class.name.in?(@opts[:except])
            clone = @cell.dup
            parents(clone.class).each do |belongs_to|
              old_id = clone.send("#{belongs_to.name}_id")
              next unless old_id

              if belongs_to.options[:polymorphic]
                class_name = clone.send("#{belongs_to.name}").class.name
                if @opts[class_name] and @opts[class_name][old_id]
                  clone.send("#{belongs_to.name}=", @opts[class_name][old_id])
                end
              else
                if @opts[belongs_to.class_name] and @opts[belongs_to.class_name][old_id]
                  clone.send("#{belongs_to.name}=", @opts[belongs_to.class_name][old_id])
                end
              end
            end
            yield(@cell, clone, :before_save) if block_given?
            clone.save if clone.new_record? # avoid save again if saved on block
            yield(@cell, clone, :after_save) if block_given?
            raise "#{clone.class} - #{clone.errors.full_messages.join(', ')}" if clone.errors.any?
            @opts[clone.class.name][@cell.id] = clone
          end
          leafs(@cell).each do |cell|
            @opts[:source] << cell if block_given? and not yield(cell, cell, :skip?)
          end
          leafs_statuses["#{@cell.class.name}_#{@cell.id}"] = true
        end
      end
    end

    def safe_child?(child, parent)
      !child.respond_to?("#{parent.name}_id".to_sym) or
      child.send("#{parent.name}_id").nil? or
      @opts[parent.class_name][child.send("#{parent.name}_id")] or
      parent.class_name.in? @opts[:except]
      # replicated parent?
    end

    # Need to check the relations instead the models only
    def walk?(cell)
      parents(cell.class).map do |p|
        if p.options[:polymorphic]
          if cell.respond_to?("#{p.name}_id".to_sym) and cell.send("#{p.name}_id")
            class_name = cell.send("#{p.name}").class.name
            @opts[class_name] = {} unless @opts[class_name]
            @opts[class_name][cell.send("#{p.name}_id")] or class_name.in? @opts[:except] # replicated parent?
          else
            true
          end
        else
          @opts[p.class_name] = {} unless @opts[p.class_name]
          safe_child = safe_child?(cell, p)
          @must_ignore << p.class_name unless safe_child
          safe_child
        end
      end.all?(&:present?)
    end

    def leafs(cell)
      node = cell.class
      arr = []
      node.reflect_on_all_associations(:has_one).each do |c|
        unless c.class_name.in? @opts[:except]
          leaf = cell.send(c.name)
          arr << leaf if leaf&.persisted? and (@opts[:source].nil? or (not leaf.in? @opts[:source]))
        end
      end
      node.reflect_on_all_associations(:has_many).each do |c|
        unless c.class_name.in? @opts[:except]
          cell.send(c.name).find_in_batches.each do |leafs|
            leafs.each do |leaf|
              arr << leaf if leaf&.persisted? and (@opts[:source].nil? or (not leaf.in? @opts[:source]))
            end
          end
        end
      end
      arr
    end

    def parents(node)
      parents = node.reflect_on_all_associations(:belongs_to) # name and class_name
    end
  end
end
