class Item < ActiveRecord::Base
  validates :name, :category, :height, :width, :length, :weight,
    presence: true

  validates :height, :width, :length, :weight,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.query(query_params)

      # Basic validation to ensure all inputs are numerical, no strings allowed
      query_params.each do | key, value |
        if value.is_a? String
          response = "All inputs must be numerical"
          return response
        end
      end

      # Order space dimensions, so there'a high, middle, low value
      # By convention, the highest dimension becomes length
      #                the middle width
      #                the low height
      ordered_array = [ query_params[:length], query_params[:width], query_params[:height] ].sort
      provided_length = ordered_array[2]
      provided_width = ordered_array[1]
      provided_height = ordered_array[0]

      # Get a collection of all the options
      options = Item.all

      # Create an empty hash to store results
      results_hash = {}

      # Fill in the Results Hash
        options.each do |option|

        # Step 1:  Order the dimensions of the given option.
        # By convention, length gets high value, then width, height gets low value.
        options_ordered_array = [ option.length, option.width, option.height ].sort
        option_length = options_ordered_array[2]
        option_width = options_ordered_array[1]
        option_height = options_ordered_array[0]

        # Step 2: Determine the sum of the differential between the
        # query dimensions and the option dimensions
        # in all 3 space dimensions.
        # Add sum to the Results Hash.
        length_dif = option_length - provided_length
        width_dif = option_width - provided_width
        height_dif = option_height - provided_height
        spatial_dif = length_dif + width_dif + height_dif

        # Populate the Results Hash
        inner_hash = { "spatial dif" => spatial_dif }
        results_hash["#{option.id}"] = inner_hash

        #Step 3: Determine if query dimensions fit inside a given option
        if
          (option_length >= provided_length) &&
          (option_width >= provided_width) &&
          (option_height >= provided_height)
          # It fits => Add key (fits) with value (true) to inner hash
          results_hash["#{option.id}"]["Fits"] = true
        else
          # It doesn't fit => Add key (fits) with value (false) to inner hash
          results_hash["#{option.id}"]["Fits"] = false
        end

        # Step 4: Determine if weight dimension met
        if
          (query_params[:weight] <= option.weight)
          # criteria met
          results_hash["#{option.id}"]["Light Enough"] = true
        else
          # It's too heavy
          results_hash["#{option.id}"]["Light Enough"] = false
        end
      end # Results Hash Created, end

      # Sort Results Hash
      results_hash_sorted = results_hash.sort_by do | key, value |
        value["spatial dif"]
      end

      # Debugging - hash table info
      puts results_hash_sorted

      # Pick first option that meets criteria from the Ordered Results Hash
      # This will be the "answer"
      results_hash_sorted.each do | key, value |
         if value["Fits"] == true && value["Light Enough"] == true
           @response = key
           @response = @response.to_i
           break
         else
           @response = nil
         end
      end

      return @response

  end  # End Method Definition
end
