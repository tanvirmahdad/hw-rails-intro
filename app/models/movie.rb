class Movie < ActiveRecord::Base
    def self.ratingRetriver
        ratingCollection=Movie.distinct.pluck(:rating)
        return ratingCollection
    end
end