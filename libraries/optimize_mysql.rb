module Mysql
  module Optimization
    
    #Based on:
    # - http://www.mysqlperformanceblog.com/2007/11/01/innodb-performance-optimization-basics/
    # - http://www.activo.com/why-optimizing-innodb-is-key-for-magento-performance
    def optimize_mysql(system_type = :shared)
      memory                                            =     total_memory
      multiples                                         =     {}
      calculated                                        =     {}
                                                              
      if (system_type.eql?(:dedicated))                       
        multiples['innodb_buffer_pool_size']            =     0.5
                                                              
      elsif (system_type.eql?(:shared))                       
        multiples['innodb_buffer_pool_size']            =     0.25
      end                                                     
                                                              
      multiples['query_cache_size']                     =     0.25
      multiples['query_cache_limit']                    =     0.125
      multiples['tmp_table_size']                       =     0.125
      multiples['key_buffer_size']                      =     0.03125
      multiples['read_buffer_size']                     =     0.0625
      multiples['read_rnd_buffer_size']                 =     0.0625
      multiples['sort_buffer_size']                     =     0.03125
      multiples['join_buffer_size']                     =     0.03125
      multiples['bulk_insert_buffer_size']              =     0.03125
                                                              
      multiples['myisam_sort_buffer_size']              =     0.0625
      multiples['myisam_max_sort_file_size']            =     0.0625
                                                              
      multiples['innodb_additional_mem_pool_size']      =     0.125
      
      if (memory && memory > 0)
        multiples.each do |key, multiple|
          value             =   (memory.to_f * multiple).round
          calculated[key]   =   "#{value}M" unless value.nil?
        end
      end
      
      return calculated
    end
    
    def total_memory
      memory            =   nil
      
      begin
        memory_output   =   %x(free -m)
        lines           =   memory_output.split("\n").collect {|line| line.strip}
        memory_line     =   lines[1]
        columns         =   memory_line.split(" ")
        memory          =   columns[1].to_i
        
        Chef::Log.info("The system has a total memory of #{memory}mb.")
        
      rescue => e
        Chef::Log.info("Failed to parse the system's total memory. Error Class: #{e.class.name}. Error Message: #{e.message}")
      end
      
      return memory
    end
    
    def total_cpu_cores
      cores             =   nil
      
      begin
        cpu_output      =   %x(cat /proc/cpuinfo | grep processor | wc -l)
        cores           =   cpu_output.strip.to_i rescue nil
        
        Chef::Log.info("The system has a total of #{cores} CPU Cores.")
        
      rescue => e
        Chef::Log.info("Failed to parse the system's number of CPU Cores. Error Class: #{e.class.name}. Error Message: #{e.message}")
      end
      
      return cores
    end
    
  end
end