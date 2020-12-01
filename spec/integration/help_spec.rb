# frozen_string_literal: true

require 'spec_helper'

describe 'help.html', js: true, type: :feature do
  before do
    visit '/help.html'
  end
  it 'renders help' do
    expect(title).to eq('Shell: Help')
  end
end
