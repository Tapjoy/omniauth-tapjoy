require 'spec_helper'

describe OmniAuth::Strategies::Tapjoy do
  subject do
    OmniAuth::Strategies::Tapjoy.new({})
  end

  context "client options" do
    it 'should have correct name' do
      subject.options.name.should eq(:tapjoy)
    end

    it 'should have the correct default production site' do
      subject.options.client_options.site.should eq('https://oauth.tapjoy.com')
      OmniAuth::Strategies::Tapjoy.site.should eq('https://oauth.tapjoy.com')
    end

    it 'should use the correct environment site override' do
      stub_const("ENV", { 'TAPJOY_AUTH_SITE' => 'https://test.tapjoy.com' })
      # Can't test the subject directly here as the site was set on class load, but you could still overwrite
      # it via an options hash if you wanted to
      OmniAuth::Strategies::Tapjoy.site.should eq('https://test.tapjoy.com')
    end

    it 'should use the correct staging site' do
      stub_const("ENV", { 'TAPJOY_USE_STAGING_AUTH' => 'true' })
      # Can't test the subject directly here as the site was set on class load, but you could still overwrite
      # it via an options hash if you wanted to
      OmniAuth::Strategies::Tapjoy.site.should eq('https://mystique-staging.herokuapp.com')
    end

    it 'should have the correct default authorize url' do
      subject.options.client_options.authorize_path.should eq('/oauth/authorize')
      OmniAuth::Strategies::Tapjoy.authorize_path.should eq('/oauth/authorize')
    end

    it 'should use the correct authorize url override' do
      stub_const("ENV", { 'TAPJOY_AUTH_PATH' => '/a/different/path' })
      # Can't test the subject directly here as the url was set on class load, but you could still overwrite
      # it via an options hash if you wanted to
      OmniAuth::Strategies::Tapjoy.authorize_path.should eq('/a/different/path')
    end

    it 'should use the correct staging authorize url' do
      stub_const("ENV", { 'TAPJOY_USE_STAGING_AUTH' => 'true' })
      # Can't test the subject directly here as the url was set on class load, but you could still overwrite
      # it via an options hash if you wanted to
      OmniAuth::Strategies::Tapjoy.authorize_path.should eq('/oauth/authorize')
    end
  end
end
