require 'roo'
require 'json'

suppliers = JSON.parse(File.read('./lib/tasks/management_consultancy/output/suppliers.json'))
suppliers.each { |supplier| supplier['lots'] = [] }

service_offerings_workbook = Roo::Spreadsheet.open './lib/tasks/management_consultancy/input/Service offerings.xlsx'

def extract_service_number(service_name)
  service_name.split('[')[1].split(']')[0]
end

def extract_duns(supplier_name)
  supplier_name.split('[')[1].split(']')[0].to_i
end

(0..10).each do |sheet_number|
  sheet = service_offerings_workbook.sheet(sheet_number)
  service_names = sheet.column(1)
  lot_number = extract_service_number(service_names[1]).match(/MCF\d[.]\d+/).to_s

  (2..sheet.last_column).each do |column_number|
    column = sheet.column(column_number)
    supplier_duns = extract_duns(column.first)
    service_offerings = []
    column.each_with_index do |value, index|
      next unless value.to_s.downcase == 'x'

      next if service_names[index].nil?

      service_offerings << extract_service_number(service_names[index])
    end

    next unless service_offerings.size.positive?

    supplier = suppliers.find { |s| s['duns'] == supplier_duns }
    supplier['lots'] << { 'lot_number' => lot_number, 'services' => service_offerings } if supplier
  end
end

File.open('./lib/tasks/management_consultancy/output/suppliers_with_service_offerings.json', 'w') do |f|
  f.write JSON.pretty_generate suppliers
end
