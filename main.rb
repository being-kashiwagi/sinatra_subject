# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

def read_all_memos
  memo = []
  File.open('./public/memo.json') do |f|
    memo = JSON.parse(f.read)
  end
  memo
end

def read_memo(id, memos)
  memo = memos.filter { |item| item['id'] == id }
  { title: memo[0]['title'], content: memo[0]['content'] }
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
  @title = memo[:title]
  @content = memo[:content]
  erb :detail_page
end

get '/memo/edit-page' do
  @id = params[:id]
  memo = read_memo(params[:id], read_all_memos)
  @title = memo[:title]
  @content = memo[:content]
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
  memos = read_all_memos
  memos.each do |memo|
    if memo['id'] == params['id']
      memo['title'] = params['title']
      memo['content'] = params['content']
    end
  end
  File.open('./public/memo.json', 'w') do |f|
    JSON.dump(memos, f)
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
