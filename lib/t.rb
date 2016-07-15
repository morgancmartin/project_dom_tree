require './parser'

html = "This is my <a>header link</a></h1>"



html_string = "<div>  div text before  <p>    p text  </p>  <div>    more div text  </div>  div text after</div>"

hp = HTMLParser.new

hp.load_test_html

hp.fill_stack

hp.print_stack



# p hp.open_tag?(hp.find_next_tag(html)[0])
# p hp.find_next_tag(html)



# until @html.empty?
#   cur_tag = find_next_tag
#   make_t_node(@stack.last[1], cur_tag[1]) if 
#   if close_tag?(cur_tag)
#     make_node(@stack.last, cur_tag)
#     shorten_html(@stack.last[1], cur_tag[1])
#   elsif open_tag?(cur_tag) && @stack.length > 1
#     make_t_node(@stack.last[1], cur_tag[1])
#     end
# end
