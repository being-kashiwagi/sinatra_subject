# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/escape'

# メモ保存ファイルから全てのメモ情報を取得する
# @return memo_data:全てのメモデータ
def read_all_memodata
  memo_data = []
  File.open('./public/memo_data.json') do |f|
    memo_data = JSON.parse(f.read)
  end
  memo_data
end

# メモ保存ファイルからidが一致するメモを取得する
# @param id:メモid
# @param memo_data:全てのメモデータ(read_all_memodataの結果)
# @return title:idに一致したメモのタイトル
# @return content:idに一致したメモの内容
def read_pick_memodata(id, memo_data)
  title = ''
  content = ''
  memo_data.length.times do |i|
    if memo_data[i]['id'].to_s == id.to_s
      title = memo_data[i]['title']
      content = memo_data[i]['content']
    end
  end
  [title, content]
end

# トップページを取得する
get '/' do
  @memo_data = read_all_memodata
  erb :top_page
end

# メモ新規作成ページを取得する
get '/memo/create-page' do
  erb :create_page
end

# メモ内容表示ページを取得する
get '/memo/detail-page/:id' do
  @id = params[:id]
  @title, @content = read_pick_memodata(params[:id], read_all_memodata)
  erb :detail_page
end

# メモ内容編集ページを取得する
get '/memo/edit-page' do
  @id = params[:id]
  @title, @content = read_pick_memodata(params[:id], read_all_memodata)
  erb :edit_page
end

# メモを登録する
post '/memo' do
  memo_data = read_all_memodata
  File.open('./public/memo_data.json', 'w') do |f|
    hash = { "id": params['id'], "title": CGI.escapeHTML(params['title']), "content": CGI.escapeHTML(params['content']).gsub(/\R/, '<br>') }
    memo_data.push(hash)
    JSON.dump(memo_data, f)
  end
  redirect to '/'
end

# メモを更新する
patch '/memo' do
  memo_data = read_all_memodata
  memo_data.length.times do |i|
    if memo_data[i]['id'].to_s == params['id'].to_s
      memo_data[i]['title'] = CGI.escapeHTML(params['title'])
      memo_data[i]['content'] = CGI.escapeHTML(params['content']).gsub(/\R/, '<br>')
    end
  end
  File.open('./public/memo_data.json', 'w') do |f|
    JSON.dump(memo_data, f)
  end
  redirect to '/'
end

# メモを削除する
delete '/memo' do
  memo_data = read_all_memodata
  memo_data.delete_if do |memo|
    memo['id'] == params['id']
  end
  File.open('./public/memo_data.json', 'w') do |f|
    JSON.dump(memo_data, f)
  end
  redirect to '/'
end

# 存在しないURLアクセスへの対応
not_found do
  '404 Not Found'
end
