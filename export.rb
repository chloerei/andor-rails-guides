require 'fileutils'

FileUtils.rm_r 'export'
FileUtils.mkdir_p 'export/docbook'
FileUtils.mkdir_p 'export/md'

Dir['manuscript/*.adoc'].each do |adoc|
  `asciidoctor -D export/docbook -b docbook5 #{adoc}`
end

Dir['export/docbook/*.xml'].each do |docbook|
  `pandoc -f docbook -t markdown_github #{docbook} -o export/md/#{File.basename docbook, '.xml'}.md`
end
