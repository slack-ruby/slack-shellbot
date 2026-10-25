# frozen_string_literal: true

require 'spec_helper'

describe 'help.html', :js, type: :feature do
  before do
    visit '/help.html'
  end

  it 'renders help' do
    expect(title).to eq('Shell: Help')
  end

  it 'expands the command reference with the keyboard' do
    summary = find('summary', text: 'Command reference')
    expect(page).to have_no_css('pre', visible: :visible)
    summary.send_keys(:enter)
    expect(page).to have_css('pre', text: SlackShellbot::Commands::Man::HELP.strip)
    summary.send_keys(:enter)
    expect(page).to have_no_css('pre', visible: :visible)
  end
end
