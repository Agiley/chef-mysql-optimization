module ChefMysqlOptimization
  module Mysql
    module Optimization
      
      def binary_path_with_args(binary = 'mysql_bin')
        "#{node['mysql'][binary]} -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\""
      end
      
      #Based on:
      # - http://www.mysqlperformanceblog.com/2007/11/01/innodb-performance-optimization-basics/
      # - http://www.activo.com/why-optimizing-innodb-is-key-for-magento-performance
      def optimize_mysql(system_type = :shared)
        memory                                            =     memory_in_megabytes
        multiples                                         =     {}
        calculated                                        =     {}

        if (system_type.eql?(:dedicated))
          multiples['innodb_buffer_pool_size']            =     50

        elsif (system_type.eql?(:shared))
          multiples['innodb_buffer_pool_size']            =     25
        end

        multiples['innodb_additional_mem_pool_size']      =     12.5

        multiples['query_cache_size']                     =     25
        multiples['query_cache_limit']                    =     12.5

        multiples['tmp_table_size']                       =     12.5
        multiples['key_buffer_size']                      =     3.125
        multiples['read_buffer_size']                     =     6.25
        multiples['read_rnd_buffer_size']                 =     6.25
        multiples['sort_buffer_size']                     =     3.125
        multiples['join_buffer_size']                     =     3.125
        multiples['bulk_insert_buffer_size']              =     3.125
        
        multiples.each do |key, multiple|
          value             =   memory_by_percentage(memory, multiple)
          calculated[key]   =   "#{value}M" unless value.nil?
        end if memory && memory > 0

        return calculated
      end
      
      def memory_in_megabytes
        return case node[:os]
          when /.*bsd/
            node[:memory][:total].to_i / 1024 / 1024
          when 'linux'
            node[:memory][:total][/\d*/].to_i / 1024
          when 'darwin'
            node[:memory][:total][/\d*/].to_i
          when 'windows', 'solaris', 'hpux', 'aix'
            node[:memory][:total][/\d*/].to_i / 1024
          end
      end
    
      def memory_by_percentage(memory, percentage)
        percentage    =   (percentage.to_f / 100.0)
        (memory.to_f * percentage).floor
      end

    end
  end
end