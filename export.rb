require 'fileutils'
require 'nokogiri'

FileUtils.mkdir_p 'export/docbook'
FileUtils.mkdir_p 'export/md'
FileUtils.rm Dir['export/docbook/*']
FileUtils.rm Dir['export/md/*']

Dir['manuscript/*.adoc'].each do |adoc|
  `asciidoctor -D export/docbook -b docbook5 #{adoc}`
end

Dir['export/docbook/*.xml'].each do |docbook|
  `pandoc -f docbook -t markdown_github #{docbook} -o export/md/#{File.basename docbook, '.xml'}.md`
end

Dir['export/md/*.md'].each do |file|
  content = File.read file

  content.gsub! /^-   /, '- '
  content.gsub! /^``` (.*)$/, '```\1'

  content.gsub!(/<table>.+?<\/table>/m) do |html|
    doc = Nokogiri::HTML(html)
    lines = []

    if head = doc.at_css('thead tr')
      titles = head.css('th').map{|th| " #{th.content} "}
      lines << ['|', titles.join('|'), '|'].join
      lines << ['|', titles.map{|title| '-' * title.length }.join('|'), '|'].join
    end

    doc.css('tbody tr').each do |tr|
      lines << ['|', tr.css('td').map{|td| " #{td.content} "}.join('|'), '|'].join
    end

    lines.join("\n")
  end

  File.open(file, 'w') { |f| f.write content }
end
