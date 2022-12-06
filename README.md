# sinatraでメモアプリを作成する課題

## アプリケーション実行手順

- 任意のディレクトリを作成し、ソースコードを配置後、`bundle init`を実行する。
- `./Gemfile`に以下のgemを追記し、保存する。
```
gem 'sinatra'
gem 'webrick'
gem 'sinatra-contrib'
gem 'redcarpet'
```
- `bundle install`を実行する。
- `bundle exec ruby main.rb`を実行する。
- ブラウザで`http://localhost:4567`にアクセスする。