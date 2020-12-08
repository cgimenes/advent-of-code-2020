class DslParser < Parslet::Parser
  root :expression_list
  rule(:expression_list) { expression.repeat(1) }
  rule(:expression) { identifier.as(:identifier) >> space >> contain >> space >> content.as(:content) >> dot >> eol }
  rule(:contain) { str('bags contain') }
  rule(:identifier) { match['a-z'].repeat >> space >> match['a-z'].repeat }
  rule(:eol) { str("\n").maybe }
  rule(:dot) { str(".") }
  rule(:space) { match('\s').repeat }
  rule(:quantity) { match['0-9'].repeat(1) }
  rule(:bag) { quantity.as(:quantity) >> space >> identifier.as(:identifier) >> space >> str('bag') >> str('s').maybe }
  rule(:bags) { (bag >> str(', ').maybe).repeat(1) }
  rule(:no_bags) { str('no other bags') }
  rule(:content) { bags | no_bags }
end

class DslTransform < Parslet::Transform
  rule(identifier: simple(:identifier), content: 'no other bags') do
    {
      identifier: identifier,
      content: []
    }
  end
  rule(quantity: simple(:quantity), identifier: simple(:identifier)) do
    {
      identifier: identifier,
      quantity: quantity.to_i
    }
  end
end
