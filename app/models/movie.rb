class Movie < ActiveRecord::Base
    def self.ratingRetriver
        ratingCollection=Movie.distinct.pluck(:rating)
        return ratingCollection
    end
    
    def self.with_ratings(keys)
        filtered=Movie.where("rating IN (?)", keys)
        return filtered
    end
end