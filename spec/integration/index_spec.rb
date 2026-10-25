# frozen_string_literal: true

require 'spec_helper'

describe 'index.html', :js, type: :feature do
  before do
    ENV['SLACK_CLIENT_ID'] = 'slack-client-id'
    visit '/'
  end

  after do
    ENV.delete 'SLACK_CLIENT_ID'
  end

  it 'includes a link to add to slack with the client id' do
    expect(title).to eq('Shell: A Unix Shell in Every Slack Channel')
    expect(first('p[id=register] a')['href']).to eq 'https://slack.com/oauth/v2/authorize?scope=chat:write,im:history,mpim:history,channels:history,groups:history&client_id=slack-client-id'
  end

  it 'links to the joke FAQ with its answer visible' do
    click_link 'Is this a joke?'
    expect(page).to have_current_path('/help.html', ignore_query: true)
    expect(page).to have_css('#is-this-a-joke p', text: 'Yes. Also, it works!')
  end

  it 'loads the generated stylesheet and versioned artwork after a reload' do
    page.refresh
    background = page.evaluate_script("getComputedStyle(document.body, '::before').backgroundImage")
    expect(background).to match(%r{/img/screenshot-background\.svg\?v=[a-f0-9]{64}})
    expect(page).to have_css('.hero-preview img') { |image| image.evaluate_script('this.complete && this.naturalWidth > 0') }
  end

  it 'links to the bot recommendations after How to use in navigation' do
    expect(page).to have_css('.nav-links a[href="/#how-to-use"] + a[href="/#more-bots"]', text: /More bots/i)
    within('nav') { click_link 'More bots' }
    expect(page).to have_css('#more-bots h3', text: 'Strava in Slack')
  end

  it 'promotes the other bots above the open-source section' do
    expect(page).to have_css('#more-bots + #open-source')
    within('#more-bots') do
      {
        'Slava' => 'https://slava.playplay.io/',
        'Strada' => 'https://strada.playplay.io/',
        'Gamebot' => 'https://gamebot2.playplay.io/',
        "S'Up" => 'https://sup2.playplay.io/'
      }.each do |name, url|
        expect(page).to have_link("Meet #{name}", href: url)
      end
    end
  end

  it "loads the promoted bots' original logos" do
    find_by_id('more-bots').execute_script("this.scrollIntoView({block: 'center'})")
    expect(page).to have_css('#more-bots img.bot-logo', count: 4) do |image|
      image.evaluate_script('this.complete && this.naturalWidth > 0')
    end
    expect(all('#more-bots h3').map(&:text)).to eq(['Strava in Slack', 'Strava in Discord', "S'Up for Slack", 'Leaderboards in Slack'])
    expect(page).to have_css('#bots-title', text: /More bots for Slack and Discord/i)
  end

  it 'keeps navigation and installation usable on small screens' do
    page.execute_script("document.body.innerHTML = '<iframe id=\"mobile\" title=\"Mobile\" src=\"/\" width=\"320\" style=\"border:0\"></iframe>'")
    within_frame('mobile') do
      expect(page.evaluate_script('window.innerWidth')).to eq(320)
      expect(page.evaluate_script('document.documentElement.scrollWidth <= window.innerWidth')).to be true
      expect(page).to have_link('Add to Slack', count: 2)
      within('nav') { click_link 'Help' }
      expect(page).to have_css('h1', text: 'Shell: Help')
    end
  end
end
