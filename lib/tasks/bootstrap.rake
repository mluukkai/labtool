    namespace :bootstrap do

      desc "Create score types for checklists"
      task :default_scoretypes => :environment do
        Scoretype.create :name => "Viikkopisteet", :varname => "points", :max => 60
        Scoretype.create :name => "Arvosanapisteet", :varname => "gradepoints", :max => 60
        Scoretype.create :name => "Arvosanamaksimi", :varname => "maxgrade", :max => 5, :initial => 5, :min => 1
        Scoretype.create :name => "Arvosana", :varname => "grade", :max => 5, :initial => 0, :min => 0
      end

      desc "Run all bootstrapping tasks"
      task :all => [:default_scoretypes]
    end
