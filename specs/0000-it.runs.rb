
describe 'Rex_Dots' do

  it "runs the code from README.md" do
    file     = File.expand_path(File.dirname(__FILE__) + '/../README.md')
    contents = File.read( file )
    code = (contents[/```ruby([^`]+)```/] && $1).split("\n").reject { |str| str['puts'] }.join "\n"

    should.not.raise {
      eval(code, nil, file, contents.split("\n").index('```ruby') + 1)
    }
  end # === it

end # === describe 'Rex_Dots'

describe 'Rex_Dots?' do

  it "returns a MatchData object" do
    r = Rex_Dots?("hello ( (...) ) { (...) } ", "hello ( a, b, c ) { hello }")
    r.class.should == MatchData
  end # === it

end # === describe 'Rex_Dots?'

describe ':exp' do

  it "creates a regular expression" do
    r = Rex_Dots.exp(" (...) { (...) } ")
    r.match "hello { hello }"
    $1.should == 'hello'
  end # === it

  it "allows: ( (...) )" do
    r = Rex_Dots.exp("(...) ( (...) )")
    r.match "add ( 5 + 5 )"
    $2.should == '5 + 5'
  end # === it

  it "captures parentheses: math ( 2 + 2 ) { ... }" do
    r = Rex_Dots.exp("(...) (...)")
    r.match "add ( 5 + 5 )"
    $2.should == '( 5 + 5 )'
  end # === it

end # === describe ':exp'
