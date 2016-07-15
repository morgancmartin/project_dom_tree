
def parse_p_tag(html)
  parse_tag('p', html)
end

def parse_a_tag(html)
  parse_tag('a', html)
end

def r_to_s(regex)
  regex.to_s[7..-2]
end

def s_to_r(string)
  Regexp.new(string)
end




#Need to know if a tag contains a tag...

* Search until you find an opening tag...
** Throw that opening tag onto the stack...
** If you find another opening tag, throw it onto the stack.
** Once you find a closing tag, match it up with your most recent opening tag on the stack...

** Create a tag out of it based on the information between...


opening tags can be determined based off of <>'s....
also they should insure that there are no \'s before either
bracket... eh... forget the advanced parsing for now...

closing tags are the same deal except that you should insure that
they have /'s before their type
