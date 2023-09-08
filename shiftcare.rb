require 'json'

class ShiftCare
  def initialize(file)
    @clients = JSON.parse(File.read(file))
  end

  def search_by_name(name)
    matching_clients = @clients.select { |client| client['full_name'].downcase.include?(name.downcase) }
    if matching_clients.empty?
      puts "No clients found with names matching '#{name}'."
    else
      puts "Clients with names partially matching '#{name}':"
      matching_clients.each { |client| puts "#{client['id']}: #{client['full_name']} (#{client['email']})" }
    end
  end

  def duplicate_email
    email_count = Hash.new(0)
    @clients.each do |client|
      email_count[client['email']] += 1
    end
    duplicates = email_count.select { |_email, count| count > 1 }
    if duplicates.empty?
      puts 'No duplicate clients found by email.'
    else
      puts 'Duplicate clients found by email:'
      duplicates.each do |email, count|
        duplicate_clients = @clients.select { |client| client['email'] == email }
        duplicate_clients.each do |client|
          puts "#{client['id']}: #{client['full_name']} (#{client['email']})"
        end
      end
    end
  end
end

shiftcare = ShiftCare.new('clients.json')
puts "\nChoose an option:"
puts "1. Search clients by name"
puts "2. Find duplicate clients by email"
print "Enter your choice: "
choice = gets.chomp.to_i
if choice == 1
  print 'Enter a name: '
  name = gets.chomp
  shiftcare.search_by_name(name)
elsif choice == 2
  shiftcare.duplicate_email
else
  puts 'Invalid choice. Please select a valid option.'
end
