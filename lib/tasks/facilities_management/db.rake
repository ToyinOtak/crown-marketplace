module CCS
  require 'pg'
  require 'csv'
  require 'json'
  require './lib/tasks/distributed_locks'

  def self.csv_to_nuts_regions(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query('create table IF NOT EXISTS nuts_regions (code varchar(255) UNIQUE, name varchar(255),
      nuts1_code varchar(255), nuts2_code varchar(255) );')
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| '"' + i + '"' }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        db.exec_query("DELETE FROM nuts_regions where code = '" + row['code'] + "' ; ")
        db.exec_query('insert into nuts_regions ( ' + column_names + ') values (' + values + ')')
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.csv_to_fm_regions(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      db.exec_query('create table IF NOT EXISTS fm_regions (code varchar(255) UNIQUE, name varchar(255) );')
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| '"' + i + '"' }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        db.exec_query("DELETE FROM fm_regions where code = '" + row['code'] + "' ; ")
        db.exec_query('insert into fm_regions ( ' + column_names + ') values (' + values + ')')
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.csv_to_fm_rates(file_name)
    ActiveRecord::Base.connection_pool.with_connection do |db|
      query = 'create table IF NOT EXISTS fm_rates (code varchar(255) UNIQUE, framework numeric, benchmark numeric );
      TRUNCATE TABLE fm_rates;'
      db.query query
      CSV.read(file_name, headers: true).each do |row|
        column_names = row.headers.map { |i| '"' + i.to_s + '"' }.join(',')
        values = row.fields.map { |i| "'#{i}'" }.join(',')
        query = "DELETE FROM fm_rates where code = '" + row['code'] + "' ; " \
                'insert into fm_rates ( ' + column_names + ') values (' + values + ')'
        db.query query
      end
    end
  rescue PG::Error => e
    puts e.message
  end

  def self.load_static(directory = 'data/')
    DistributedLocks.distributed_lock(150) do
      p "Loading NUTS static data, Environment: #{Rails.env}"
      CCS.csv_to_nuts_regions directory + 'nuts1_regions.csv'
      CCS.csv_to_nuts_regions directory + 'nuts2_regions.csv'
      CCS.csv_to_nuts_regions directory + 'nuts3_regions.csv'
      p "Finished loading NUTS codes into db #{Rails.application.config.database_configuration[Rails.env]['database']}"

      CCS.csv_to_fm_regions directory + 'facilities_management/regions.csv'
      p 'Loading FM rates static data'
      CCS.csv_to_fm_rates directory + 'facilities_management/rates.csv'
    end
  end
end

namespace :db do
  desc 'add NUTS static data to the database'
  task static: :environment do
    p 'Loading NUTS static'
    CCS.load_static
  end

  desc 'add static data to the database'
  task setup: :static do
  end
end