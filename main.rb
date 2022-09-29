# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/escape'

def read_all_memos
  memo = []
  File.open('./public/memo.json') do |f|
    memo = JSON.parse(f.read)
  end
  memo
end

def read_memo(id, memo)
  title = ''
  content = ''
  memo.length.times do |i|
    if memo[i]['id'].to_s == id.to_s
      title = memo[i]['title']
      content = memo[i]['content']
    end
  end
  { title: title, content: content }
end

get '/' do
  @memos = read_all_memos
  erb :top_page
end

get '/memo/create-page' do
  erb :create_page
end

get '/memo/detail-page/:id' do
  @id = params[:id]
  memo = read_memo(params[:id], read_all_memos)
  @title = CGI.escapeHTML(memo[:title])
  @content = CGI.escapeHTML(memo[:content]).gsub(/\R/, '<br>')
  erb :detail_page
end

get '/memo/edit-page' do
  @id = params[:id]
  memo = read_memo(params[:id], read_all_memos)
  @title = CGI.escapeHTML(memo[:title])
  @content = CGI.escapeHTML(memo[:content]).gsub(/\R/, '<br>')
  erb :edit_page
end

post '/memo' do
  memo = read_all_memos
  File.open('./public/memo.json', 'w') do |f|
    hash = { id: params['id'], title: params['title'], content: params['content'] }
    memo.push(hash)
    JSON.dump(memo, f)
  end
  redirect to '/'
end

patch '/memo' do
  memo = read_all_memos
  memo.length.times do |i|
    if memo[i]['id'].to_s == params['id'].to_s
      memo[i]['title'] = params['title']
      memo[i]['content'] = params['content']
    end
  end
  File.open('./public/memo.json', 'w') do |f|
    JSON.dump(memo, f)
  end
  redirect to '/'
end

delete '/memo' do
  memos = read_all_memos
  memos.delete_if do |memo|
    memo['id'] == params['id']
  end
  File.open('./public/memo.json', 'w') do |f|
    JSON.dump(memos, f)
  end
  redirect to '/'
end

not_found do
  '404 Not Found'
end
