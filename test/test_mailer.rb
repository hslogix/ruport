require "test/unit"
require "ruport"
require "ruport/mailer"

class TestMailer < Test::Unit::TestCase

  def setup
    @default_opts = {
      :host => "mail.example.com", 
      :address => "sue@example.com", 
      :user => "inky",
      :password => "chunky"
    }

    @other_opts = {
      :host => "moremail.example.com",
      :address => "clyde@example.com",
      :user => "blinky",
      :password => "bacon"
    }

    Ruport::Config.mailer :default, @default_opts
    Ruport::Config.mailer :other, @other_opts

    @default_mailer = Ruport::Mailer.new
    @other_mailer = Ruport::Mailer.new :other 
  end
    
  def assert_mailer_equal(expected, mailer)
    assert_equal expected[:host], mailer.instance_variable_get(:@host)
    assert_equal expected[:address], mailer.instance_variable_get(:@address)
    assert_equal expected[:user], mailer.instance_variable_get(:@user)
    assert_equal expected[:password], mailer.instance_variable_get(:@password)
  end
  
  def test_default_constructor    
    assert_mailer_equal @default_opts, @default_mailer
  end
  
  def test_constructor_with_mailer_label
    assert_mailer_equal @other_opts, @other_mailer
  end
  
  def test_select_mailer
    mailer = Ruport::Mailer.new :default
    assert_mailer_equal @default_opts, mailer

    mailer.select_mailer :other
    assert_mailer_equal @other_opts, mailer
  end
  
end
