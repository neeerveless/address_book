### 住所録作ります。＠ｗ＠

## 雛形作成

```
catalyst.pl AddressBook::Web
mv AddressBook-Web/* ./
./script/addressbook_web_create.pl view TT TT
./script/addressbook_web_create.pl model DBIC DBIC::Schema AddressBook::Web::Schema create=static dbi:mysql:address_book test_user test_password
```
