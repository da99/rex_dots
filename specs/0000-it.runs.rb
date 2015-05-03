
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
