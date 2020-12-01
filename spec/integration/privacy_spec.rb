# frozen_string_literal: true

require 'spec_helper'

describe 'privacy.html', js: true, type: :feature do
  before do
    visit '/privacy.html'
  end
  it 'renders privacy policy' do
    expect(title).to eq('Shell: Privacy Policy')
  end
end
