//
//  XMSQL+create.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/16.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

import Foundation
//MARK: - create (创建表)
extension XMSQL {
    ///书 - create
    static var create_book_sql: XMSQL = XMSQL(sql: "CREATE TABLE `book` (`bookId` INTEGER NOT NULL, `name` TEXT NOT NULL, `chapterCount` INTEGER NOT NULL, `authorName` TEXT NOT NULL, `authorId` INTEGER NOT NULL, `caption` TEXT NOT NULL, `shortCaption` TEXT NOT NULL, `category` TEXT NOT NULL, `subcategory` TEXT NOT NULL, `lastChapterId` INTEGER NOT NULL, `lastChapterTitle` TEXT NOT NULL, `voteNumber` INTEGER NOT NULL, `readNumber` INTEGER NOT NULL, `status` INTEGER NOT NULL, `label` TEXT NOT NULL, `tags` TEXT NOT NULL, `wordCount` INTEGER NOT NULL, `sectionId` INTEGER NOT NULL, `entireSubscribe` INTEGER NOT NULL, `bookUpdateTime`, `cover` TEXT INTEGER NOT NULL, PRIMARY KEY(`bookId`))")
    
    ///用户 - create
    static var create_user_sql: XMSQL = XMSQL(sql:"CREATE TABLE `user` (`uid` INTEGER NOT NULL, `nick` TEXT NOT NULL, `avatar` TEXT NOT NULL, `mobile` TEXT NOT NULL, `regTime` INTEGER NOT NULL, `vipLevel` INTEGER NOT NULL, `vipTime` INTEGER NOT NULL, `vipExpiredTime` INTEGER NOT NULL, `coin` INTEGER NOT NULL, `premium` INTEGER NOT NULL, `checkedIn` INTEGER, `vipState` INTEGER NOT NULL, `lastLoginType` INTEGER, `token` TEXT, `lastLoginTime` INTEGER,`email` TEXT, PRIMARY KEY(`uid`))")
    ///阅读记录，书架 - create
    static var create_library_sql: XMSQL = XMSQL(sql:"CREATE TABLE `library` (`bookId` INTEGER NOT NULL, `chapterId` INTEGER, `chapterPosition` INTEGER, `chapterTitle` TEXT, `readTime` INTEGER, `favorite` INTEGER, `autoSubscribe` INTEGER,`updateBook` INTEGER, PRIMARY KEY(`bookId`))")
    ///白名单 - create
    static var create_book_white_list_sql: XMSQL = XMSQL(sql:"CREATE TABLE `book_white_list` (`id` INTEGER NOT NULL, PRIMARY KEY(`id`))")
    ///评论，点赞 - create
    static var create_comment_like_sql: XMSQL = XMSQL(sql:"CREATE TABLE `comment_like` (`id` INTEGER NOT NULL, `like` INTEGER NOT NULL, PRIMARY KEY(`id`))")
    ///阅读时长 - create
    static var create_reading_statistic_sql: XMSQL = XMSQL(sql:"CREATE TABLE `reading_statistic` (`date` INTEGER NOT NULL, `userId` INTEGER NOT NULL, `totalTimeSeconds` INTEGER NOT NULL, `pendingTimeSeconds` INTEGER NOT NULL, PRIMARY KEY(`date`, `userId`))")
    ///搜索记录 - create
    static var create_search_history_sql: XMSQL = XMSQL(sql:"CREATE TABLE `search_history` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `keyword` TEXT NOT NULL, `count` INTEGER)")
    ///书架操作记录(用户删除等) - create
    static var create_shelf_op_sql: XMSQL = XMSQL(sql:"CREATE TABLE `shelf_op` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `bookId` INTEGER NOT NULL, `op` INTEGER NOT NULL)")
    ///用户订阅章节 - create
    static var create_subscribe_sql: XMSQL = XMSQL(sql:"CREATE TABLE `subscribe` (`bookId` INTEGER NOT NULL, `chapterId` INTEGER, `entire` INTEGER, `userId` INTEGER NOT NULL, PRIMARY KEY(`bookId`, `chapterId`, `userId`))")
    
    
    
    
    
    static var create_bookshelf_sql: XMSQL = XMSQL(sql:"CREATE VIEW bookshelf as select book.*, library.chapterId, library.chapterPosition, library.chapterTitle, library.readTime,library.updateBook from library join book on library.bookId=book.bookId where library.favorite=1 order by library.readTime DESC")
    static var create_auto_subscribe_sql: XMSQL = XMSQL(sql:"CREATE VIEW auto_subscribe_book as select book.*, library.chapterId, library.chapterPosition, library.chapterTitle, library.readTime from library join book on library.bookId=book.bookId where library.autoSubscribe=1 order by library.readTime DESC")
    
    static var create_latest_read_log_sql: XMSQL = XMSQL(sql:"CREATE VIEW latest_read_log as select book.*, library.chapterId, library.chapterPosition,library.updateBook, library.chapterTitle, library.readTime from library join book on library.bookId=book.bookId where chapterId>0 order by library.readTime DESC")
}
