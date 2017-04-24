require 'kramdown'
require 'rouge'

class Markdown
  LINK_REGEXP = %r((?<![=["|']|><a-z0-9_\.])(?<!http:\/\/)((http[s]?\:\/\/)?([a-z0-9\.]+\.[a-z]{2,5}(\/[\?=&a-z0-9_\.\/]+)?)))
  CHECKBOX_REGEXP_CHECKED = %r(\K\[(x|X)\]\s?(.*)<)
  CHECKBOX_REGEXP_UNCHECKED = %r(\K\[ \]\s?(.*)<)

  def self.parse(text)
    html = ::Kramdown::Document.new(text,
                                    input: 'GFM',
                                    coderay_csscoderay_css: :class,
                                    syntax_highlighter: :rouge).to_html
    html.gsub(CHECKBOX_REGEXP_CHECKED, %(<input type="checkbox" checked disabled><label>\\2</label><))
        .gsub(CHECKBOX_REGEXP_UNCHECKED, %(<input type="checkbox" disabled><label>\\1</label><))
        .gsub(LINK_REGEXP, '<a href="\1">\1</a>')
  end
end
