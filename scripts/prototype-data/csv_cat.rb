require 'csv'
require 'optionparser'

options = {
  out_file: 'output.csv'
}
parser = OptionParser.new do |opts|

  opts.banner = <<EOF
Usage: #{File.basename __FILE__} [options] --institution=INSTITUTION XML [XML ..]

Concatenate CSVs.

EOF

  # directory
  out_help = "The output file [default 'output.csv']"
  opts.on('-o file', '--outfile=FILE', out_help) do |path|
    options[:out_file] = path
  end

  # sort
  sort_help = "Sort combined records by first item"
  opts.on '-s', '--sort', sort_help do |sort|
    options[:sort] = sort
  end

  uniq_help = 'Return only uniq values'
  opts.on '-u', '--uniq', uniq_help do |uniq|
    options[:uniq] = uniq
  end

  # verbose
  verb_help = "Print full error messages"
  opts.on('-v', '--verbose', TrueClass, verb_help) do |verbose|
    options[:verbose] = verbose
  end

  help_help = <<~EOF
    Prints this help

  EOF
  opts.on("-h", "--help", help_help) do
    puts opts
    exit
  end
end

parser.parse!

csvs = ARGV.select { |f| File.exist? f}

abort "No input CSVs found #{ARGV.join ', '}" if csvs.empty?
header = CSV.readlines(csvs.first).first

data = []
csvs.each do |in_file|
  if File.exist? in_file
    data += CSV.readlines(in_file)[1..-1]
  else
    puts "WARNING: input file not found: #{in_file}"
  end
end

data.sort_by! &:first if options[:sort]
data.uniq! &:join     if options[:uniq]

CSV.open options[:out_file], 'wb', headers: true do |csv|
  csv << header
  data.each do |row|
    csv << row
  end
end

puts "Wrote: #{options[:out_file]}"