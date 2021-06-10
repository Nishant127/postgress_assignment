# Library Management System 📖📚

## Features of Library Management System:
- #### Add New Member entry.
- #### Add New Book entry.
- #### Member cannot issue more than 5 Books.
- #### Search book by its Title, Author, Subject Category and Publication Date.
- #### Fine Calculation if book is not returned before the return date.
- #### Member can reserve the book if it is available.

## Tables included in the Database:
- #### members
  <img src="https://i.imgur.com/w9TfzBB.png">
- #### books
  <img src="https://i.imgur.com/CdbuxxN.png">
- #### issued_books
  <img src="https://i.imgur.com/VeZqBeY.png">
- #### reserve_books
  <img src="https://i.imgur.com/UQLU9Oa.png">
- #### book_fines
  <img src="https://i.imgur.com/uvjCrj4.png">

## Commands:
- ### Add a new member
```
INSERT INTO members(member_name,city,date_register,issued_books,email) VALUES (your_entered_values)
```
- ### Add a new book
```
INSERT INTO books(title,author,pub_date,sub_cat,rack_no,book_items) VALUES (your_entered_values)
```
- ### Issue a book
```
INSERT INTO issued_books(member_id,book_id,date_issue,date_return,date_returned,issue_status) VALUES (your_entered_values)
```
- ### Reserve a book
```
INSERT INTO reserve_books(member_id,book_id,alloted) VALUES (your_entered_values)
```
- ### Collect reserved book
```
UPDATE reserve_books SET alloted='Alloted' WHERE id='(your_entered_value)'
```
- ### Search book
```
SELECT * FROM books WHERE title/author/pub_date/sub_cat='(your_entered_value)'
```
- ### Check fine if book not submitted in the given time
```
SELECT * FROM book_fines 
```
