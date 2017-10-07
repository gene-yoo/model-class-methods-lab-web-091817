class Captain < ActiveRecord::Base
  has_many :boats

  def self.catamaran_operators
    Captain.joins(boats: :classifications).where("classifications.name = 'Catamaran'")
  end

  def self.sailors
    Captain.joins(boats: :classifications).distinct.where("classifications.name = 'Sailboat'")
  end

  def self.talented_seamen
    motorboats = Captain.joins(boats: :classifications).where("classifications.name = 'Motorboat'")
    sailboats = Captain.joins(boats: :classifications).where("classifications.name = 'Sailboat'")

    seamen = motorboats.intersect(sailboats)

    Captain.from(Captain.arel_table.create_table_alias(seamen, :captains))
  end

  def self.non_sailors
    captains = Captain.all.distinct
    sailors = self.sailors
    non_sailors = captains - sailors

    non_sailors_table = Captain.where(id: non_sailors.map(&:id))
  end
end
