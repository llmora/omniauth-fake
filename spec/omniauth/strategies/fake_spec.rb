require "spec_helper"

describe OmniAuth::Strategies::Fake do

  let(:app) do
    Rack::Builder.new {
      use OmniAuth::Test::PhonySession
      use OmniAuth::Strategies::Fake, dotfiles: [File.expand_path('../../../omniauth-fake.yml', __FILE__)]
      run lambda { |env| [404, {'Content-Type' => 'text/plain'}, [env.key?('omniauth.auth').to_s]] }
    }.to_app
  end

  context 'client options' do
    subject do
      OmniAuth::Strategies::Fake.new({})
    end

    it { expect(subject.options.dotfiles).to eq([File.join(ENV['HOME'], '.omniauth-fake')]) }
  end

  describe 'get /auth/fake' do
    before(:each) { get '/auth/fake' }

    it 'should display a form' do
      expect(last_response.body).to include('<form')
    end

    it 'should have the callback as the form action' do
      expect(last_response.body).to include(%q{action='/auth/fake/callback'})
    end

    it 'should have the correct title' do
      expect(last_response.body).to include('Identity Selection')
    end

    it 'should have the Identities as options' do
      expect(last_response.body).to include('<option value="user1">user1 - John Doe')
    end
  end # get /auth/fake

  describe 'post /auth/fake/callback' do
    context 'no uid present' do
      it 'should redirect to the error page' do
        post('/auth/fake/callback', {})
        expect(last_response).to be_redirect
        expect(last_response.headers['location']).to match(/missing_credentials/)

        post('/auth/fake/callback', {uid: ''})
        expect(last_response).to be_redirect
        expect(last_response.headers['location']).to match(/missing_credentials/)
      end
    end

    context 'unknown uid present' do
      it 'should redirect to the error page' do
        post('/auth/fake/callback', {uid: "does not exist"})
        expect(last_response).to be_redirect
        expect(last_response.headers['location']).to match(/invalid_credentials/)
      end
    end

    context 'valid uid' do
      let(:auth_hash) { last_request.env['omniauth.auth'] }

      it 'should not redirect to the error page' do
        post('/auth/fake/callback', {uid: "user1"})
        expect(last_response).to_not be_redirect
      end

      it 'should map all user1 info to the Auth Hash' do
        post('/auth/fake/callback', {uid: "user1"})
        expect(auth_hash.provider).to eq('fake')
        expect(auth_hash.uid).to eq('user1')

        expect(auth_hash.info.name).to eq('John Doe')
        expect(auth_hash.info.email).to eq('user1@example.com')

        expect(auth_hash.credentials.token).to eq('my_app_token')
        expect(auth_hash.credentials.secret).to eq('super-secret-token')

        expect(auth_hash.extra.raw_info.uid).to eq('user1')
        expect(auth_hash.extra.raw_info.name).to eq('John Doe')
        expect(auth_hash.extra.raw_info.email).to eq('user1@example.com')
        expect(auth_hash.extra.raw_info.credentials).to eq({
          "token" => 'my_app_token',
          "secret" => 'super-secret-token'
        })
        expect(auth_hash.extra.raw_info.sAMAccountName).to eq('abcuser1')
        expect(auth_hash.extra.raw_info.attribute_x).to eq('Value')
      end

      it 'should map all user1 info to the Auth Hash' do
        post('/auth/fake/callback', {uid: "user2"})
        expect(auth_hash.provider).to eq('fake')
        expect(auth_hash.uid).to eq('user2')

        expect(auth_hash.info.name).to eq('Jane Doe')
        expect(auth_hash.extra.raw_info.uid).to eq('user2')
        expect(auth_hash.extra.raw_info.name).to eq('Jane Doe')
      end
    end

  end # post /auth/fake/callback
end
