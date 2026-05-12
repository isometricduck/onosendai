// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FeedPostsTableTable extends FeedPostsTable
    with TableInfo<$FeedPostsTableTable, FeedPost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedPostsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorUsernameMeta = const VerificationMeta(
    'authorUsername',
  );
  @override
  late final GeneratedColumn<String> authorUsername = GeneratedColumn<String>(
    'author_username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicsMeta = const VerificationMeta('topics');
  @override
  late final GeneratedColumn<String> topics = GeneratedColumn<String>(
    'topics',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repliesCountMeta = const VerificationMeta(
    'repliesCount',
  );
  @override
  late final GeneratedColumn<int> repliesCount = GeneratedColumn<int>(
    'replies_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookmarksCountMeta = const VerificationMeta(
    'bookmarksCount',
  );
  @override
  late final GeneratedColumn<int> bookmarksCount = GeneratedColumn<int>(
    'bookmarks_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPublicMeta = const VerificationMeta(
    'isPublic',
  );
  @override
  late final GeneratedColumn<bool> isPublic = GeneratedColumn<bool>(
    'is_public',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_public" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isNsfwMeta = const VerificationMeta('isNsfw');
  @override
  late final GeneratedColumn<bool> isNsfw = GeneratedColumn<bool>(
    'is_nsfw',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_nsfw" IN (0, 1))',
    ),
  );
  static const VerificationMeta _attachmentsMeta = const VerificationMeta(
    'attachments',
  );
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
    'attachments',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasAudioAttachmentMeta =
      const VerificationMeta('hasAudioAttachment');
  @override
  late final GeneratedColumn<bool> hasAudioAttachment = GeneratedColumn<bool>(
    'has_audio_attachment',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_audio_attachment" IN (0, 1))',
    ),
  );
  static const VerificationMeta _audioAttachmentGenreMeta =
      const VerificationMeta('audioAttachmentGenre');
  @override
  late final GeneratedColumn<String> audioAttachmentGenre =
      GeneratedColumn<String>(
        'audio_attachment_genre',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    postId,
    authorId,
    authorUsername,
    content,
    topics,
    repliesCount,
    bookmarksCount,
    isPublic,
    isNsfw,
    attachments,
    hasAudioAttachment,
    audioAttachmentGenre,
    createdAt,
    deleted,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feed_posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedPost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_username')) {
      context.handle(
        _authorUsernameMeta,
        authorUsername.isAcceptableOrUnknown(
          data['author_username']!,
          _authorUsernameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorUsernameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('topics')) {
      context.handle(
        _topicsMeta,
        topics.isAcceptableOrUnknown(data['topics']!, _topicsMeta),
      );
    } else if (isInserting) {
      context.missing(_topicsMeta);
    }
    if (data.containsKey('replies_count')) {
      context.handle(
        _repliesCountMeta,
        repliesCount.isAcceptableOrUnknown(
          data['replies_count']!,
          _repliesCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repliesCountMeta);
    }
    if (data.containsKey('bookmarks_count')) {
      context.handle(
        _bookmarksCountMeta,
        bookmarksCount.isAcceptableOrUnknown(
          data['bookmarks_count']!,
          _bookmarksCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bookmarksCountMeta);
    }
    if (data.containsKey('is_public')) {
      context.handle(
        _isPublicMeta,
        isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta),
      );
    } else if (isInserting) {
      context.missing(_isPublicMeta);
    }
    if (data.containsKey('is_nsfw')) {
      context.handle(
        _isNsfwMeta,
        isNsfw.isAcceptableOrUnknown(data['is_nsfw']!, _isNsfwMeta),
      );
    } else if (isInserting) {
      context.missing(_isNsfwMeta);
    }
    if (data.containsKey('attachments')) {
      context.handle(
        _attachmentsMeta,
        attachments.isAcceptableOrUnknown(
          data['attachments']!,
          _attachmentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attachmentsMeta);
    }
    if (data.containsKey('has_audio_attachment')) {
      context.handle(
        _hasAudioAttachmentMeta,
        hasAudioAttachment.isAcceptableOrUnknown(
          data['has_audio_attachment']!,
          _hasAudioAttachmentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasAudioAttachmentMeta);
    }
    if (data.containsKey('audio_attachment_genre')) {
      context.handle(
        _audioAttachmentGenreMeta,
        audioAttachmentGenre.isAcceptableOrUnknown(
          data['audio_attachment_genre']!,
          _audioAttachmentGenreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_audioAttachmentGenreMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {postId};
  @override
  FeedPost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedPost(
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      authorUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_username'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      topics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topics'],
      )!,
      repliesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}replies_count'],
      )!,
      bookmarksCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bookmarks_count'],
      )!,
      isPublic: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_public'],
      )!,
      isNsfw: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_nsfw'],
      )!,
      attachments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments'],
      )!,
      hasAudioAttachment: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_audio_attachment'],
      )!,
      audioAttachmentGenre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_attachment_genre'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $FeedPostsTableTable createAlias(String alias) {
    return $FeedPostsTableTable(attachedDatabase, alias);
  }
}

class FeedPost extends DataClass implements Insertable<FeedPost> {
  final String postId;
  final String authorId;
  final String authorUsername;
  final String content;
  final String topics;
  final int repliesCount;
  final int bookmarksCount;
  final bool isPublic;
  final bool isNsfw;
  final String attachments;
  final bool hasAudioAttachment;
  final String audioAttachmentGenre;
  final DateTime createdAt;
  final bool deleted;
  final DateTime fetchedAt;
  const FeedPost({
    required this.postId,
    required this.authorId,
    required this.authorUsername,
    required this.content,
    required this.topics,
    required this.repliesCount,
    required this.bookmarksCount,
    required this.isPublic,
    required this.isNsfw,
    required this.attachments,
    required this.hasAudioAttachment,
    required this.audioAttachmentGenre,
    required this.createdAt,
    required this.deleted,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['post_id'] = Variable<String>(postId);
    map['author_id'] = Variable<String>(authorId);
    map['author_username'] = Variable<String>(authorUsername);
    map['content'] = Variable<String>(content);
    map['topics'] = Variable<String>(topics);
    map['replies_count'] = Variable<int>(repliesCount);
    map['bookmarks_count'] = Variable<int>(bookmarksCount);
    map['is_public'] = Variable<bool>(isPublic);
    map['is_nsfw'] = Variable<bool>(isNsfw);
    map['attachments'] = Variable<String>(attachments);
    map['has_audio_attachment'] = Variable<bool>(hasAudioAttachment);
    map['audio_attachment_genre'] = Variable<String>(audioAttachmentGenre);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['deleted'] = Variable<bool>(deleted);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  FeedPostsTableCompanion toCompanion(bool nullToAbsent) {
    return FeedPostsTableCompanion(
      postId: Value(postId),
      authorId: Value(authorId),
      authorUsername: Value(authorUsername),
      content: Value(content),
      topics: Value(topics),
      repliesCount: Value(repliesCount),
      bookmarksCount: Value(bookmarksCount),
      isPublic: Value(isPublic),
      isNsfw: Value(isNsfw),
      attachments: Value(attachments),
      hasAudioAttachment: Value(hasAudioAttachment),
      audioAttachmentGenre: Value(audioAttachmentGenre),
      createdAt: Value(createdAt),
      deleted: Value(deleted),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory FeedPost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedPost(
      postId: serializer.fromJson<String>(json['postId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorUsername: serializer.fromJson<String>(json['authorUsername']),
      content: serializer.fromJson<String>(json['content']),
      topics: serializer.fromJson<String>(json['topics']),
      repliesCount: serializer.fromJson<int>(json['repliesCount']),
      bookmarksCount: serializer.fromJson<int>(json['bookmarksCount']),
      isPublic: serializer.fromJson<bool>(json['isPublic']),
      isNsfw: serializer.fromJson<bool>(json['isNsfw']),
      attachments: serializer.fromJson<String>(json['attachments']),
      hasAudioAttachment: serializer.fromJson<bool>(json['hasAudioAttachment']),
      audioAttachmentGenre: serializer.fromJson<String>(
        json['audioAttachmentGenre'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'postId': serializer.toJson<String>(postId),
      'authorId': serializer.toJson<String>(authorId),
      'authorUsername': serializer.toJson<String>(authorUsername),
      'content': serializer.toJson<String>(content),
      'topics': serializer.toJson<String>(topics),
      'repliesCount': serializer.toJson<int>(repliesCount),
      'bookmarksCount': serializer.toJson<int>(bookmarksCount),
      'isPublic': serializer.toJson<bool>(isPublic),
      'isNsfw': serializer.toJson<bool>(isNsfw),
      'attachments': serializer.toJson<String>(attachments),
      'hasAudioAttachment': serializer.toJson<bool>(hasAudioAttachment),
      'audioAttachmentGenre': serializer.toJson<String>(audioAttachmentGenre),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deleted': serializer.toJson<bool>(deleted),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  FeedPost copyWith({
    String? postId,
    String? authorId,
    String? authorUsername,
    String? content,
    String? topics,
    int? repliesCount,
    int? bookmarksCount,
    bool? isPublic,
    bool? isNsfw,
    String? attachments,
    bool? hasAudioAttachment,
    String? audioAttachmentGenre,
    DateTime? createdAt,
    bool? deleted,
    DateTime? fetchedAt,
  }) => FeedPost(
    postId: postId ?? this.postId,
    authorId: authorId ?? this.authorId,
    authorUsername: authorUsername ?? this.authorUsername,
    content: content ?? this.content,
    topics: topics ?? this.topics,
    repliesCount: repliesCount ?? this.repliesCount,
    bookmarksCount: bookmarksCount ?? this.bookmarksCount,
    isPublic: isPublic ?? this.isPublic,
    isNsfw: isNsfw ?? this.isNsfw,
    attachments: attachments ?? this.attachments,
    hasAudioAttachment: hasAudioAttachment ?? this.hasAudioAttachment,
    audioAttachmentGenre: audioAttachmentGenre ?? this.audioAttachmentGenre,
    createdAt: createdAt ?? this.createdAt,
    deleted: deleted ?? this.deleted,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  FeedPost copyWithCompanion(FeedPostsTableCompanion data) {
    return FeedPost(
      postId: data.postId.present ? data.postId.value : this.postId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorUsername: data.authorUsername.present
          ? data.authorUsername.value
          : this.authorUsername,
      content: data.content.present ? data.content.value : this.content,
      topics: data.topics.present ? data.topics.value : this.topics,
      repliesCount: data.repliesCount.present
          ? data.repliesCount.value
          : this.repliesCount,
      bookmarksCount: data.bookmarksCount.present
          ? data.bookmarksCount.value
          : this.bookmarksCount,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      isNsfw: data.isNsfw.present ? data.isNsfw.value : this.isNsfw,
      attachments: data.attachments.present
          ? data.attachments.value
          : this.attachments,
      hasAudioAttachment: data.hasAudioAttachment.present
          ? data.hasAudioAttachment.value
          : this.hasAudioAttachment,
      audioAttachmentGenre: data.audioAttachmentGenre.present
          ? data.audioAttachmentGenre.value
          : this.audioAttachmentGenre,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedPost(')
          ..write('postId: $postId, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('content: $content, ')
          ..write('topics: $topics, ')
          ..write('repliesCount: $repliesCount, ')
          ..write('bookmarksCount: $bookmarksCount, ')
          ..write('isPublic: $isPublic, ')
          ..write('isNsfw: $isNsfw, ')
          ..write('attachments: $attachments, ')
          ..write('hasAudioAttachment: $hasAudioAttachment, ')
          ..write('audioAttachmentGenre: $audioAttachmentGenre, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    postId,
    authorId,
    authorUsername,
    content,
    topics,
    repliesCount,
    bookmarksCount,
    isPublic,
    isNsfw,
    attachments,
    hasAudioAttachment,
    audioAttachmentGenre,
    createdAt,
    deleted,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedPost &&
          other.postId == this.postId &&
          other.authorId == this.authorId &&
          other.authorUsername == this.authorUsername &&
          other.content == this.content &&
          other.topics == this.topics &&
          other.repliesCount == this.repliesCount &&
          other.bookmarksCount == this.bookmarksCount &&
          other.isPublic == this.isPublic &&
          other.isNsfw == this.isNsfw &&
          other.attachments == this.attachments &&
          other.hasAudioAttachment == this.hasAudioAttachment &&
          other.audioAttachmentGenre == this.audioAttachmentGenre &&
          other.createdAt == this.createdAt &&
          other.deleted == this.deleted &&
          other.fetchedAt == this.fetchedAt);
}

class FeedPostsTableCompanion extends UpdateCompanion<FeedPost> {
  final Value<String> postId;
  final Value<String> authorId;
  final Value<String> authorUsername;
  final Value<String> content;
  final Value<String> topics;
  final Value<int> repliesCount;
  final Value<int> bookmarksCount;
  final Value<bool> isPublic;
  final Value<bool> isNsfw;
  final Value<String> attachments;
  final Value<bool> hasAudioAttachment;
  final Value<String> audioAttachmentGenre;
  final Value<DateTime> createdAt;
  final Value<bool> deleted;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const FeedPostsTableCompanion({
    this.postId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorUsername = const Value.absent(),
    this.content = const Value.absent(),
    this.topics = const Value.absent(),
    this.repliesCount = const Value.absent(),
    this.bookmarksCount = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.isNsfw = const Value.absent(),
    this.attachments = const Value.absent(),
    this.hasAudioAttachment = const Value.absent(),
    this.audioAttachmentGenre = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeedPostsTableCompanion.insert({
    required String postId,
    required String authorId,
    required String authorUsername,
    required String content,
    required String topics,
    required int repliesCount,
    required int bookmarksCount,
    required bool isPublic,
    required bool isNsfw,
    required String attachments,
    required bool hasAudioAttachment,
    required String audioAttachmentGenre,
    required DateTime createdAt,
    required bool deleted,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : postId = Value(postId),
       authorId = Value(authorId),
       authorUsername = Value(authorUsername),
       content = Value(content),
       topics = Value(topics),
       repliesCount = Value(repliesCount),
       bookmarksCount = Value(bookmarksCount),
       isPublic = Value(isPublic),
       isNsfw = Value(isNsfw),
       attachments = Value(attachments),
       hasAudioAttachment = Value(hasAudioAttachment),
       audioAttachmentGenre = Value(audioAttachmentGenre),
       createdAt = Value(createdAt),
       deleted = Value(deleted),
       fetchedAt = Value(fetchedAt);
  static Insertable<FeedPost> custom({
    Expression<String>? postId,
    Expression<String>? authorId,
    Expression<String>? authorUsername,
    Expression<String>? content,
    Expression<String>? topics,
    Expression<int>? repliesCount,
    Expression<int>? bookmarksCount,
    Expression<bool>? isPublic,
    Expression<bool>? isNsfw,
    Expression<String>? attachments,
    Expression<bool>? hasAudioAttachment,
    Expression<String>? audioAttachmentGenre,
    Expression<DateTime>? createdAt,
    Expression<bool>? deleted,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (postId != null) 'post_id': postId,
      if (authorId != null) 'author_id': authorId,
      if (authorUsername != null) 'author_username': authorUsername,
      if (content != null) 'content': content,
      if (topics != null) 'topics': topics,
      if (repliesCount != null) 'replies_count': repliesCount,
      if (bookmarksCount != null) 'bookmarks_count': bookmarksCount,
      if (isPublic != null) 'is_public': isPublic,
      if (isNsfw != null) 'is_nsfw': isNsfw,
      if (attachments != null) 'attachments': attachments,
      if (hasAudioAttachment != null)
        'has_audio_attachment': hasAudioAttachment,
      if (audioAttachmentGenre != null)
        'audio_attachment_genre': audioAttachmentGenre,
      if (createdAt != null) 'created_at': createdAt,
      if (deleted != null) 'deleted': deleted,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeedPostsTableCompanion copyWith({
    Value<String>? postId,
    Value<String>? authorId,
    Value<String>? authorUsername,
    Value<String>? content,
    Value<String>? topics,
    Value<int>? repliesCount,
    Value<int>? bookmarksCount,
    Value<bool>? isPublic,
    Value<bool>? isNsfw,
    Value<String>? attachments,
    Value<bool>? hasAudioAttachment,
    Value<String>? audioAttachmentGenre,
    Value<DateTime>? createdAt,
    Value<bool>? deleted,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return FeedPostsTableCompanion(
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorUsername: authorUsername ?? this.authorUsername,
      content: content ?? this.content,
      topics: topics ?? this.topics,
      repliesCount: repliesCount ?? this.repliesCount,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      isPublic: isPublic ?? this.isPublic,
      isNsfw: isNsfw ?? this.isNsfw,
      attachments: attachments ?? this.attachments,
      hasAudioAttachment: hasAudioAttachment ?? this.hasAudioAttachment,
      audioAttachmentGenre: audioAttachmentGenre ?? this.audioAttachmentGenre,
      createdAt: createdAt ?? this.createdAt,
      deleted: deleted ?? this.deleted,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorUsername.present) {
      map['author_username'] = Variable<String>(authorUsername.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (topics.present) {
      map['topics'] = Variable<String>(topics.value);
    }
    if (repliesCount.present) {
      map['replies_count'] = Variable<int>(repliesCount.value);
    }
    if (bookmarksCount.present) {
      map['bookmarks_count'] = Variable<int>(bookmarksCount.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<bool>(isPublic.value);
    }
    if (isNsfw.present) {
      map['is_nsfw'] = Variable<bool>(isNsfw.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (hasAudioAttachment.present) {
      map['has_audio_attachment'] = Variable<bool>(hasAudioAttachment.value);
    }
    if (audioAttachmentGenre.present) {
      map['audio_attachment_genre'] = Variable<String>(
        audioAttachmentGenre.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedPostsTableCompanion(')
          ..write('postId: $postId, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('content: $content, ')
          ..write('topics: $topics, ')
          ..write('repliesCount: $repliesCount, ')
          ..write('bookmarksCount: $bookmarksCount, ')
          ..write('isPublic: $isPublic, ')
          ..write('isNsfw: $isNsfw, ')
          ..write('attachments: $attachments, ')
          ..write('hasAudioAttachment: $hasAudioAttachment, ')
          ..write('audioAttachmentGenre: $audioAttachmentGenre, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarkedPostsTableTable extends BookmarkedPostsTable
    with TableInfo<$BookmarkedPostsTableTable, BookmarkedPost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarkedPostsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookmarkIdMeta = const VerificationMeta(
    'bookmarkId',
  );
  @override
  late final GeneratedColumn<String> bookmarkId = GeneratedColumn<String>(
    'bookmark_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorUsernameMeta = const VerificationMeta(
    'authorUsername',
  );
  @override
  late final GeneratedColumn<String> authorUsername = GeneratedColumn<String>(
    'author_username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicsMeta = const VerificationMeta('topics');
  @override
  late final GeneratedColumn<String> topics = GeneratedColumn<String>(
    'topics',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repliesCountMeta = const VerificationMeta(
    'repliesCount',
  );
  @override
  late final GeneratedColumn<int> repliesCount = GeneratedColumn<int>(
    'replies_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookmarksCountMeta = const VerificationMeta(
    'bookmarksCount',
  );
  @override
  late final GeneratedColumn<int> bookmarksCount = GeneratedColumn<int>(
    'bookmarks_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPublicMeta = const VerificationMeta(
    'isPublic',
  );
  @override
  late final GeneratedColumn<bool> isPublic = GeneratedColumn<bool>(
    'is_public',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_public" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isNsfwMeta = const VerificationMeta('isNsfw');
  @override
  late final GeneratedColumn<bool> isNsfw = GeneratedColumn<bool>(
    'is_nsfw',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_nsfw" IN (0, 1))',
    ),
  );
  static const VerificationMeta _attachmentsMeta = const VerificationMeta(
    'attachments',
  );
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
    'attachments',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasAudioAttachmentMeta =
      const VerificationMeta('hasAudioAttachment');
  @override
  late final GeneratedColumn<bool> hasAudioAttachment = GeneratedColumn<bool>(
    'has_audio_attachment',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_audio_attachment" IN (0, 1))',
    ),
  );
  static const VerificationMeta _audioAttachmentGenreMeta =
      const VerificationMeta('audioAttachmentGenre');
  @override
  late final GeneratedColumn<String> audioAttachmentGenre =
      GeneratedColumn<String>(
        'audio_attachment_genre',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookmarkId,
    postId,
    authorId,
    authorUsername,
    content,
    topics,
    repliesCount,
    bookmarksCount,
    isPublic,
    isNsfw,
    attachments,
    hasAudioAttachment,
    audioAttachmentGenre,
    createdAt,
    deleted,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarked_posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkedPost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bookmark_id')) {
      context.handle(
        _bookmarkIdMeta,
        bookmarkId.isAcceptableOrUnknown(data['bookmark_id']!, _bookmarkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookmarkIdMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_username')) {
      context.handle(
        _authorUsernameMeta,
        authorUsername.isAcceptableOrUnknown(
          data['author_username']!,
          _authorUsernameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorUsernameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('topics')) {
      context.handle(
        _topicsMeta,
        topics.isAcceptableOrUnknown(data['topics']!, _topicsMeta),
      );
    } else if (isInserting) {
      context.missing(_topicsMeta);
    }
    if (data.containsKey('replies_count')) {
      context.handle(
        _repliesCountMeta,
        repliesCount.isAcceptableOrUnknown(
          data['replies_count']!,
          _repliesCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repliesCountMeta);
    }
    if (data.containsKey('bookmarks_count')) {
      context.handle(
        _bookmarksCountMeta,
        bookmarksCount.isAcceptableOrUnknown(
          data['bookmarks_count']!,
          _bookmarksCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bookmarksCountMeta);
    }
    if (data.containsKey('is_public')) {
      context.handle(
        _isPublicMeta,
        isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta),
      );
    } else if (isInserting) {
      context.missing(_isPublicMeta);
    }
    if (data.containsKey('is_nsfw')) {
      context.handle(
        _isNsfwMeta,
        isNsfw.isAcceptableOrUnknown(data['is_nsfw']!, _isNsfwMeta),
      );
    } else if (isInserting) {
      context.missing(_isNsfwMeta);
    }
    if (data.containsKey('attachments')) {
      context.handle(
        _attachmentsMeta,
        attachments.isAcceptableOrUnknown(
          data['attachments']!,
          _attachmentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attachmentsMeta);
    }
    if (data.containsKey('has_audio_attachment')) {
      context.handle(
        _hasAudioAttachmentMeta,
        hasAudioAttachment.isAcceptableOrUnknown(
          data['has_audio_attachment']!,
          _hasAudioAttachmentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasAudioAttachmentMeta);
    }
    if (data.containsKey('audio_attachment_genre')) {
      context.handle(
        _audioAttachmentGenreMeta,
        audioAttachmentGenre.isAcceptableOrUnknown(
          data['audio_attachment_genre']!,
          _audioAttachmentGenreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_audioAttachmentGenreMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {postId};
  @override
  BookmarkedPost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkedPost(
      bookmarkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bookmark_id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      authorUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_username'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      topics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topics'],
      )!,
      repliesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}replies_count'],
      )!,
      bookmarksCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bookmarks_count'],
      )!,
      isPublic: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_public'],
      )!,
      isNsfw: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_nsfw'],
      )!,
      attachments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments'],
      )!,
      hasAudioAttachment: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_audio_attachment'],
      )!,
      audioAttachmentGenre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_attachment_genre'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $BookmarkedPostsTableTable createAlias(String alias) {
    return $BookmarkedPostsTableTable(attachedDatabase, alias);
  }
}

class BookmarkedPost extends DataClass implements Insertable<BookmarkedPost> {
  final String bookmarkId;
  final String postId;
  final String authorId;
  final String authorUsername;
  final String content;
  final String topics;
  final int repliesCount;
  final int bookmarksCount;
  final bool isPublic;
  final bool isNsfw;
  final String attachments;
  final bool hasAudioAttachment;
  final String audioAttachmentGenre;
  final DateTime createdAt;
  final bool deleted;
  final DateTime cachedAt;
  const BookmarkedPost({
    required this.bookmarkId,
    required this.postId,
    required this.authorId,
    required this.authorUsername,
    required this.content,
    required this.topics,
    required this.repliesCount,
    required this.bookmarksCount,
    required this.isPublic,
    required this.isNsfw,
    required this.attachments,
    required this.hasAudioAttachment,
    required this.audioAttachmentGenre,
    required this.createdAt,
    required this.deleted,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bookmark_id'] = Variable<String>(bookmarkId);
    map['post_id'] = Variable<String>(postId);
    map['author_id'] = Variable<String>(authorId);
    map['author_username'] = Variable<String>(authorUsername);
    map['content'] = Variable<String>(content);
    map['topics'] = Variable<String>(topics);
    map['replies_count'] = Variable<int>(repliesCount);
    map['bookmarks_count'] = Variable<int>(bookmarksCount);
    map['is_public'] = Variable<bool>(isPublic);
    map['is_nsfw'] = Variable<bool>(isNsfw);
    map['attachments'] = Variable<String>(attachments);
    map['has_audio_attachment'] = Variable<bool>(hasAudioAttachment);
    map['audio_attachment_genre'] = Variable<String>(audioAttachmentGenre);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['deleted'] = Variable<bool>(deleted);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  BookmarkedPostsTableCompanion toCompanion(bool nullToAbsent) {
    return BookmarkedPostsTableCompanion(
      bookmarkId: Value(bookmarkId),
      postId: Value(postId),
      authorId: Value(authorId),
      authorUsername: Value(authorUsername),
      content: Value(content),
      topics: Value(topics),
      repliesCount: Value(repliesCount),
      bookmarksCount: Value(bookmarksCount),
      isPublic: Value(isPublic),
      isNsfw: Value(isNsfw),
      attachments: Value(attachments),
      hasAudioAttachment: Value(hasAudioAttachment),
      audioAttachmentGenre: Value(audioAttachmentGenre),
      createdAt: Value(createdAt),
      deleted: Value(deleted),
      cachedAt: Value(cachedAt),
    );
  }

  factory BookmarkedPost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkedPost(
      bookmarkId: serializer.fromJson<String>(json['bookmarkId']),
      postId: serializer.fromJson<String>(json['postId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorUsername: serializer.fromJson<String>(json['authorUsername']),
      content: serializer.fromJson<String>(json['content']),
      topics: serializer.fromJson<String>(json['topics']),
      repliesCount: serializer.fromJson<int>(json['repliesCount']),
      bookmarksCount: serializer.fromJson<int>(json['bookmarksCount']),
      isPublic: serializer.fromJson<bool>(json['isPublic']),
      isNsfw: serializer.fromJson<bool>(json['isNsfw']),
      attachments: serializer.fromJson<String>(json['attachments']),
      hasAudioAttachment: serializer.fromJson<bool>(json['hasAudioAttachment']),
      audioAttachmentGenre: serializer.fromJson<String>(
        json['audioAttachmentGenre'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookmarkId': serializer.toJson<String>(bookmarkId),
      'postId': serializer.toJson<String>(postId),
      'authorId': serializer.toJson<String>(authorId),
      'authorUsername': serializer.toJson<String>(authorUsername),
      'content': serializer.toJson<String>(content),
      'topics': serializer.toJson<String>(topics),
      'repliesCount': serializer.toJson<int>(repliesCount),
      'bookmarksCount': serializer.toJson<int>(bookmarksCount),
      'isPublic': serializer.toJson<bool>(isPublic),
      'isNsfw': serializer.toJson<bool>(isNsfw),
      'attachments': serializer.toJson<String>(attachments),
      'hasAudioAttachment': serializer.toJson<bool>(hasAudioAttachment),
      'audioAttachmentGenre': serializer.toJson<String>(audioAttachmentGenre),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deleted': serializer.toJson<bool>(deleted),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  BookmarkedPost copyWith({
    String? bookmarkId,
    String? postId,
    String? authorId,
    String? authorUsername,
    String? content,
    String? topics,
    int? repliesCount,
    int? bookmarksCount,
    bool? isPublic,
    bool? isNsfw,
    String? attachments,
    bool? hasAudioAttachment,
    String? audioAttachmentGenre,
    DateTime? createdAt,
    bool? deleted,
    DateTime? cachedAt,
  }) => BookmarkedPost(
    bookmarkId: bookmarkId ?? this.bookmarkId,
    postId: postId ?? this.postId,
    authorId: authorId ?? this.authorId,
    authorUsername: authorUsername ?? this.authorUsername,
    content: content ?? this.content,
    topics: topics ?? this.topics,
    repliesCount: repliesCount ?? this.repliesCount,
    bookmarksCount: bookmarksCount ?? this.bookmarksCount,
    isPublic: isPublic ?? this.isPublic,
    isNsfw: isNsfw ?? this.isNsfw,
    attachments: attachments ?? this.attachments,
    hasAudioAttachment: hasAudioAttachment ?? this.hasAudioAttachment,
    audioAttachmentGenre: audioAttachmentGenre ?? this.audioAttachmentGenre,
    createdAt: createdAt ?? this.createdAt,
    deleted: deleted ?? this.deleted,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  BookmarkedPost copyWithCompanion(BookmarkedPostsTableCompanion data) {
    return BookmarkedPost(
      bookmarkId: data.bookmarkId.present
          ? data.bookmarkId.value
          : this.bookmarkId,
      postId: data.postId.present ? data.postId.value : this.postId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorUsername: data.authorUsername.present
          ? data.authorUsername.value
          : this.authorUsername,
      content: data.content.present ? data.content.value : this.content,
      topics: data.topics.present ? data.topics.value : this.topics,
      repliesCount: data.repliesCount.present
          ? data.repliesCount.value
          : this.repliesCount,
      bookmarksCount: data.bookmarksCount.present
          ? data.bookmarksCount.value
          : this.bookmarksCount,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      isNsfw: data.isNsfw.present ? data.isNsfw.value : this.isNsfw,
      attachments: data.attachments.present
          ? data.attachments.value
          : this.attachments,
      hasAudioAttachment: data.hasAudioAttachment.present
          ? data.hasAudioAttachment.value
          : this.hasAudioAttachment,
      audioAttachmentGenre: data.audioAttachmentGenre.present
          ? data.audioAttachmentGenre.value
          : this.audioAttachmentGenre,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkedPost(')
          ..write('bookmarkId: $bookmarkId, ')
          ..write('postId: $postId, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('content: $content, ')
          ..write('topics: $topics, ')
          ..write('repliesCount: $repliesCount, ')
          ..write('bookmarksCount: $bookmarksCount, ')
          ..write('isPublic: $isPublic, ')
          ..write('isNsfw: $isNsfw, ')
          ..write('attachments: $attachments, ')
          ..write('hasAudioAttachment: $hasAudioAttachment, ')
          ..write('audioAttachmentGenre: $audioAttachmentGenre, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bookmarkId,
    postId,
    authorId,
    authorUsername,
    content,
    topics,
    repliesCount,
    bookmarksCount,
    isPublic,
    isNsfw,
    attachments,
    hasAudioAttachment,
    audioAttachmentGenre,
    createdAt,
    deleted,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkedPost &&
          other.bookmarkId == this.bookmarkId &&
          other.postId == this.postId &&
          other.authorId == this.authorId &&
          other.authorUsername == this.authorUsername &&
          other.content == this.content &&
          other.topics == this.topics &&
          other.repliesCount == this.repliesCount &&
          other.bookmarksCount == this.bookmarksCount &&
          other.isPublic == this.isPublic &&
          other.isNsfw == this.isNsfw &&
          other.attachments == this.attachments &&
          other.hasAudioAttachment == this.hasAudioAttachment &&
          other.audioAttachmentGenre == this.audioAttachmentGenre &&
          other.createdAt == this.createdAt &&
          other.deleted == this.deleted &&
          other.cachedAt == this.cachedAt);
}

class BookmarkedPostsTableCompanion extends UpdateCompanion<BookmarkedPost> {
  final Value<String> bookmarkId;
  final Value<String> postId;
  final Value<String> authorId;
  final Value<String> authorUsername;
  final Value<String> content;
  final Value<String> topics;
  final Value<int> repliesCount;
  final Value<int> bookmarksCount;
  final Value<bool> isPublic;
  final Value<bool> isNsfw;
  final Value<String> attachments;
  final Value<bool> hasAudioAttachment;
  final Value<String> audioAttachmentGenre;
  final Value<DateTime> createdAt;
  final Value<bool> deleted;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const BookmarkedPostsTableCompanion({
    this.bookmarkId = const Value.absent(),
    this.postId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorUsername = const Value.absent(),
    this.content = const Value.absent(),
    this.topics = const Value.absent(),
    this.repliesCount = const Value.absent(),
    this.bookmarksCount = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.isNsfw = const Value.absent(),
    this.attachments = const Value.absent(),
    this.hasAudioAttachment = const Value.absent(),
    this.audioAttachmentGenre = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarkedPostsTableCompanion.insert({
    required String bookmarkId,
    required String postId,
    required String authorId,
    required String authorUsername,
    required String content,
    required String topics,
    required int repliesCount,
    required int bookmarksCount,
    required bool isPublic,
    required bool isNsfw,
    required String attachments,
    required bool hasAudioAttachment,
    required String audioAttachmentGenre,
    required DateTime createdAt,
    required bool deleted,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : bookmarkId = Value(bookmarkId),
       postId = Value(postId),
       authorId = Value(authorId),
       authorUsername = Value(authorUsername),
       content = Value(content),
       topics = Value(topics),
       repliesCount = Value(repliesCount),
       bookmarksCount = Value(bookmarksCount),
       isPublic = Value(isPublic),
       isNsfw = Value(isNsfw),
       attachments = Value(attachments),
       hasAudioAttachment = Value(hasAudioAttachment),
       audioAttachmentGenre = Value(audioAttachmentGenre),
       createdAt = Value(createdAt),
       deleted = Value(deleted),
       cachedAt = Value(cachedAt);
  static Insertable<BookmarkedPost> custom({
    Expression<String>? bookmarkId,
    Expression<String>? postId,
    Expression<String>? authorId,
    Expression<String>? authorUsername,
    Expression<String>? content,
    Expression<String>? topics,
    Expression<int>? repliesCount,
    Expression<int>? bookmarksCount,
    Expression<bool>? isPublic,
    Expression<bool>? isNsfw,
    Expression<String>? attachments,
    Expression<bool>? hasAudioAttachment,
    Expression<String>? audioAttachmentGenre,
    Expression<DateTime>? createdAt,
    Expression<bool>? deleted,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookmarkId != null) 'bookmark_id': bookmarkId,
      if (postId != null) 'post_id': postId,
      if (authorId != null) 'author_id': authorId,
      if (authorUsername != null) 'author_username': authorUsername,
      if (content != null) 'content': content,
      if (topics != null) 'topics': topics,
      if (repliesCount != null) 'replies_count': repliesCount,
      if (bookmarksCount != null) 'bookmarks_count': bookmarksCount,
      if (isPublic != null) 'is_public': isPublic,
      if (isNsfw != null) 'is_nsfw': isNsfw,
      if (attachments != null) 'attachments': attachments,
      if (hasAudioAttachment != null)
        'has_audio_attachment': hasAudioAttachment,
      if (audioAttachmentGenre != null)
        'audio_attachment_genre': audioAttachmentGenre,
      if (createdAt != null) 'created_at': createdAt,
      if (deleted != null) 'deleted': deleted,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarkedPostsTableCompanion copyWith({
    Value<String>? bookmarkId,
    Value<String>? postId,
    Value<String>? authorId,
    Value<String>? authorUsername,
    Value<String>? content,
    Value<String>? topics,
    Value<int>? repliesCount,
    Value<int>? bookmarksCount,
    Value<bool>? isPublic,
    Value<bool>? isNsfw,
    Value<String>? attachments,
    Value<bool>? hasAudioAttachment,
    Value<String>? audioAttachmentGenre,
    Value<DateTime>? createdAt,
    Value<bool>? deleted,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return BookmarkedPostsTableCompanion(
      bookmarkId: bookmarkId ?? this.bookmarkId,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorUsername: authorUsername ?? this.authorUsername,
      content: content ?? this.content,
      topics: topics ?? this.topics,
      repliesCount: repliesCount ?? this.repliesCount,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      isPublic: isPublic ?? this.isPublic,
      isNsfw: isNsfw ?? this.isNsfw,
      attachments: attachments ?? this.attachments,
      hasAudioAttachment: hasAudioAttachment ?? this.hasAudioAttachment,
      audioAttachmentGenre: audioAttachmentGenre ?? this.audioAttachmentGenre,
      createdAt: createdAt ?? this.createdAt,
      deleted: deleted ?? this.deleted,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookmarkId.present) {
      map['bookmark_id'] = Variable<String>(bookmarkId.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorUsername.present) {
      map['author_username'] = Variable<String>(authorUsername.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (topics.present) {
      map['topics'] = Variable<String>(topics.value);
    }
    if (repliesCount.present) {
      map['replies_count'] = Variable<int>(repliesCount.value);
    }
    if (bookmarksCount.present) {
      map['bookmarks_count'] = Variable<int>(bookmarksCount.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<bool>(isPublic.value);
    }
    if (isNsfw.present) {
      map['is_nsfw'] = Variable<bool>(isNsfw.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (hasAudioAttachment.present) {
      map['has_audio_attachment'] = Variable<bool>(hasAudioAttachment.value);
    }
    if (audioAttachmentGenre.present) {
      map['audio_attachment_genre'] = Variable<String>(
        audioAttachmentGenre.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkedPostsTableCompanion(')
          ..write('bookmarkId: $bookmarkId, ')
          ..write('postId: $postId, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('content: $content, ')
          ..write('topics: $topics, ')
          ..write('repliesCount: $repliesCount, ')
          ..write('bookmarksCount: $bookmarksCount, ')
          ..write('isPublic: $isPublic, ')
          ..write('isNsfw: $isNsfw, ')
          ..write('attachments: $attachments, ')
          ..write('hasAudioAttachment: $hasAudioAttachment, ')
          ..write('audioAttachmentGenre: $audioAttachmentGenre, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarkedRepliesTableTable extends BookmarkedRepliesTable
    with TableInfo<$BookmarkedRepliesTableTable, BookmarkedReply> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarkedRepliesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookmarkIdMeta = const VerificationMeta(
    'bookmarkId',
  );
  @override
  late final GeneratedColumn<String> bookmarkId = GeneratedColumn<String>(
    'bookmark_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _replyIdMeta = const VerificationMeta(
    'replyId',
  );
  @override
  late final GeneratedColumn<String> replyId = GeneratedColumn<String>(
    'reply_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentReplyIdMeta = const VerificationMeta(
    'parentReplyId',
  );
  @override
  late final GeneratedColumn<String> parentReplyId = GeneratedColumn<String>(
    'parent_reply_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorUsernameMeta = const VerificationMeta(
    'authorUsername',
  );
  @override
  late final GeneratedColumn<String> authorUsername = GeneratedColumn<String>(
    'author_username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookmarkId,
    replyId,
    postId,
    parentReplyId,
    authorId,
    authorUsername,
    content,
    createdAt,
    deleted,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarked_replies';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkedReply> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bookmark_id')) {
      context.handle(
        _bookmarkIdMeta,
        bookmarkId.isAcceptableOrUnknown(data['bookmark_id']!, _bookmarkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookmarkIdMeta);
    }
    if (data.containsKey('reply_id')) {
      context.handle(
        _replyIdMeta,
        replyId.isAcceptableOrUnknown(data['reply_id']!, _replyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_replyIdMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('parent_reply_id')) {
      context.handle(
        _parentReplyIdMeta,
        parentReplyId.isAcceptableOrUnknown(
          data['parent_reply_id']!,
          _parentReplyIdMeta,
        ),
      );
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_username')) {
      context.handle(
        _authorUsernameMeta,
        authorUsername.isAcceptableOrUnknown(
          data['author_username']!,
          _authorUsernameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorUsernameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {replyId};
  @override
  BookmarkedReply map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkedReply(
      bookmarkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bookmark_id'],
      )!,
      replyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_id'],
      )!,
      parentReplyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_reply_id'],
      ),
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      authorUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_username'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $BookmarkedRepliesTableTable createAlias(String alias) {
    return $BookmarkedRepliesTableTable(attachedDatabase, alias);
  }
}

class BookmarkedReply extends DataClass implements Insertable<BookmarkedReply> {
  final String bookmarkId;
  final String replyId;
  final String postId;
  final String? parentReplyId;
  final String authorId;
  final String authorUsername;
  final String content;
  final DateTime createdAt;
  final bool deleted;
  final DateTime cachedAt;
  const BookmarkedReply({
    required this.bookmarkId,
    required this.replyId,
    required this.postId,
    this.parentReplyId,
    required this.authorId,
    required this.authorUsername,
    required this.content,
    required this.createdAt,
    required this.deleted,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bookmark_id'] = Variable<String>(bookmarkId);
    map['reply_id'] = Variable<String>(replyId);
    map['post_id'] = Variable<String>(postId);
    if (!nullToAbsent || parentReplyId != null) {
      map['parent_reply_id'] = Variable<String>(parentReplyId);
    }
    map['author_id'] = Variable<String>(authorId);
    map['author_username'] = Variable<String>(authorUsername);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['deleted'] = Variable<bool>(deleted);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  BookmarkedRepliesTableCompanion toCompanion(bool nullToAbsent) {
    return BookmarkedRepliesTableCompanion(
      bookmarkId: Value(bookmarkId),
      replyId: Value(replyId),
      postId: Value(postId),
      parentReplyId: parentReplyId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentReplyId),
      authorId: Value(authorId),
      authorUsername: Value(authorUsername),
      content: Value(content),
      createdAt: Value(createdAt),
      deleted: Value(deleted),
      cachedAt: Value(cachedAt),
    );
  }

  factory BookmarkedReply.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkedReply(
      bookmarkId: serializer.fromJson<String>(json['bookmarkId']),
      replyId: serializer.fromJson<String>(json['replyId']),
      postId: serializer.fromJson<String>(json['postId']),
      parentReplyId: serializer.fromJson<String?>(json['parentReplyId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorUsername: serializer.fromJson<String>(json['authorUsername']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookmarkId': serializer.toJson<String>(bookmarkId),
      'replyId': serializer.toJson<String>(replyId),
      'postId': serializer.toJson<String>(postId),
      'parentReplyId': serializer.toJson<String?>(parentReplyId),
      'authorId': serializer.toJson<String>(authorId),
      'authorUsername': serializer.toJson<String>(authorUsername),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deleted': serializer.toJson<bool>(deleted),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  BookmarkedReply copyWith({
    String? bookmarkId,
    String? replyId,
    String? postId,
    Value<String?> parentReplyId = const Value.absent(),
    String? authorId,
    String? authorUsername,
    String? content,
    DateTime? createdAt,
    bool? deleted,
    DateTime? cachedAt,
  }) => BookmarkedReply(
    bookmarkId: bookmarkId ?? this.bookmarkId,
    replyId: replyId ?? this.replyId,
    postId: postId ?? this.postId,
    parentReplyId: parentReplyId.present
        ? parentReplyId.value
        : this.parentReplyId,
    authorId: authorId ?? this.authorId,
    authorUsername: authorUsername ?? this.authorUsername,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    deleted: deleted ?? this.deleted,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  BookmarkedReply copyWithCompanion(BookmarkedRepliesTableCompanion data) {
    return BookmarkedReply(
      bookmarkId: data.bookmarkId.present
          ? data.bookmarkId.value
          : this.bookmarkId,
      replyId: data.replyId.present ? data.replyId.value : this.replyId,
      postId: data.postId.present ? data.postId.value : this.postId,
      parentReplyId: data.parentReplyId.present
          ? data.parentReplyId.value
          : this.parentReplyId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorUsername: data.authorUsername.present
          ? data.authorUsername.value
          : this.authorUsername,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkedReply(')
          ..write('bookmarkId: $bookmarkId, ')
          ..write('replyId: $replyId, ')
          ..write('postId: $postId, ')
          ..write('parentReplyId: $parentReplyId, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bookmarkId,
    replyId,
    postId,
    parentReplyId,
    authorId,
    authorUsername,
    content,
    createdAt,
    deleted,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkedReply &&
          other.bookmarkId == this.bookmarkId &&
          other.replyId == this.replyId &&
          other.postId == this.postId &&
          other.parentReplyId == this.parentReplyId &&
          other.authorId == this.authorId &&
          other.authorUsername == this.authorUsername &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.deleted == this.deleted &&
          other.cachedAt == this.cachedAt);
}

class BookmarkedRepliesTableCompanion extends UpdateCompanion<BookmarkedReply> {
  final Value<String> bookmarkId;
  final Value<String> replyId;
  final Value<String> postId;
  final Value<String?> parentReplyId;
  final Value<String> authorId;
  final Value<String> authorUsername;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<bool> deleted;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const BookmarkedRepliesTableCompanion({
    this.bookmarkId = const Value.absent(),
    this.replyId = const Value.absent(),
    this.postId = const Value.absent(),
    this.parentReplyId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorUsername = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarkedRepliesTableCompanion.insert({
    required String bookmarkId,
    required String replyId,
    required String postId,
    this.parentReplyId = const Value.absent(),
    required String authorId,
    required String authorUsername,
    required String content,
    required DateTime createdAt,
    required bool deleted,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : bookmarkId = Value(bookmarkId),
       replyId = Value(replyId),
       postId = Value(postId),
       authorId = Value(authorId),
       authorUsername = Value(authorUsername),
       content = Value(content),
       createdAt = Value(createdAt),
       deleted = Value(deleted),
       cachedAt = Value(cachedAt);
  static Insertable<BookmarkedReply> custom({
    Expression<String>? bookmarkId,
    Expression<String>? replyId,
    Expression<String>? postId,
    Expression<String>? parentReplyId,
    Expression<String>? authorId,
    Expression<String>? authorUsername,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<bool>? deleted,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookmarkId != null) 'bookmark_id': bookmarkId,
      if (replyId != null) 'reply_id': replyId,
      if (postId != null) 'post_id': postId,
      if (parentReplyId != null) 'parent_reply_id': parentReplyId,
      if (authorId != null) 'author_id': authorId,
      if (authorUsername != null) 'author_username': authorUsername,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (deleted != null) 'deleted': deleted,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarkedRepliesTableCompanion copyWith({
    Value<String>? bookmarkId,
    Value<String>? replyId,
    Value<String>? postId,
    Value<String?>? parentReplyId,
    Value<String>? authorId,
    Value<String>? authorUsername,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<bool>? deleted,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return BookmarkedRepliesTableCompanion(
      bookmarkId: bookmarkId ?? this.bookmarkId,
      replyId: replyId ?? this.replyId,
      postId: postId ?? this.postId,
      parentReplyId: parentReplyId ?? this.parentReplyId,
      authorId: authorId ?? this.authorId,
      authorUsername: authorUsername ?? this.authorUsername,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      deleted: deleted ?? this.deleted,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookmarkId.present) {
      map['bookmark_id'] = Variable<String>(bookmarkId.value);
    }
    if (replyId.present) {
      map['reply_id'] = Variable<String>(replyId.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (parentReplyId.present) {
      map['parent_reply_id'] = Variable<String>(parentReplyId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorUsername.present) {
      map['author_username'] = Variable<String>(authorUsername.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkedRepliesTableCompanion(')
          ..write('bookmarkId: $bookmarkId, ')
          ..write('replyId: $replyId, ')
          ..write('postId: $postId, ')
          ..write('parentReplyId: $parentReplyId, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalNotesTableTable extends JournalNotesTable
    with TableInfo<$JournalNotesTableTable, JournalNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalNotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicsMeta = const VerificationMeta('topics');
  @override
  late final GeneratedColumn<String> topics = GeneratedColumn<String>(
    'topics',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    noteId,
    content,
    topics,
    revision,
    createdAt,
    deleted,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('topics')) {
      context.handle(
        _topicsMeta,
        topics.isAcceptableOrUnknown(data['topics']!, _topicsMeta),
      );
    } else if (isInserting) {
      context.missing(_topicsMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId};
  @override
  JournalNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalNote(
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      topics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topics'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $JournalNotesTableTable createAlias(String alias) {
    return $JournalNotesTableTable(attachedDatabase, alias);
  }
}

class JournalNote extends DataClass implements Insertable<JournalNote> {
  final String noteId;
  final String content;
  final String topics;
  final int revision;
  final DateTime? createdAt;
  final bool deleted;
  final DateTime fetchedAt;
  const JournalNote({
    required this.noteId,
    required this.content,
    required this.topics,
    required this.revision,
    this.createdAt,
    required this.deleted,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['content'] = Variable<String>(content);
    map['topics'] = Variable<String>(topics);
    map['revision'] = Variable<int>(revision);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  JournalNotesTableCompanion toCompanion(bool nullToAbsent) {
    return JournalNotesTableCompanion(
      noteId: Value(noteId),
      content: Value(content),
      topics: Value(topics),
      revision: Value(revision),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      deleted: Value(deleted),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory JournalNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalNote(
      noteId: serializer.fromJson<String>(json['noteId']),
      content: serializer.fromJson<String>(json['content']),
      topics: serializer.fromJson<String>(json['topics']),
      revision: serializer.fromJson<int>(json['revision']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'content': serializer.toJson<String>(content),
      'topics': serializer.toJson<String>(topics),
      'revision': serializer.toJson<int>(revision),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'deleted': serializer.toJson<bool>(deleted),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  JournalNote copyWith({
    String? noteId,
    String? content,
    String? topics,
    int? revision,
    Value<DateTime?> createdAt = const Value.absent(),
    bool? deleted,
    DateTime? fetchedAt,
  }) => JournalNote(
    noteId: noteId ?? this.noteId,
    content: content ?? this.content,
    topics: topics ?? this.topics,
    revision: revision ?? this.revision,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    deleted: deleted ?? this.deleted,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  JournalNote copyWithCompanion(JournalNotesTableCompanion data) {
    return JournalNote(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      content: data.content.present ? data.content.value : this.content,
      topics: data.topics.present ? data.topics.value : this.topics,
      revision: data.revision.present ? data.revision.value : this.revision,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalNote(')
          ..write('noteId: $noteId, ')
          ..write('content: $content, ')
          ..write('topics: $topics, ')
          ..write('revision: $revision, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    noteId,
    content,
    topics,
    revision,
    createdAt,
    deleted,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalNote &&
          other.noteId == this.noteId &&
          other.content == this.content &&
          other.topics == this.topics &&
          other.revision == this.revision &&
          other.createdAt == this.createdAt &&
          other.deleted == this.deleted &&
          other.fetchedAt == this.fetchedAt);
}

class JournalNotesTableCompanion extends UpdateCompanion<JournalNote> {
  final Value<String> noteId;
  final Value<String> content;
  final Value<String> topics;
  final Value<int> revision;
  final Value<DateTime?> createdAt;
  final Value<bool> deleted;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const JournalNotesTableCompanion({
    this.noteId = const Value.absent(),
    this.content = const Value.absent(),
    this.topics = const Value.absent(),
    this.revision = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalNotesTableCompanion.insert({
    required String noteId,
    required String content,
    required String topics,
    required int revision,
    this.createdAt = const Value.absent(),
    required bool deleted,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : noteId = Value(noteId),
       content = Value(content),
       topics = Value(topics),
       revision = Value(revision),
       deleted = Value(deleted),
       fetchedAt = Value(fetchedAt);
  static Insertable<JournalNote> custom({
    Expression<String>? noteId,
    Expression<String>? content,
    Expression<String>? topics,
    Expression<int>? revision,
    Expression<DateTime>? createdAt,
    Expression<bool>? deleted,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (content != null) 'content': content,
      if (topics != null) 'topics': topics,
      if (revision != null) 'revision': revision,
      if (createdAt != null) 'created_at': createdAt,
      if (deleted != null) 'deleted': deleted,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalNotesTableCompanion copyWith({
    Value<String>? noteId,
    Value<String>? content,
    Value<String>? topics,
    Value<int>? revision,
    Value<DateTime?>? createdAt,
    Value<bool>? deleted,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return JournalNotesTableCompanion(
      noteId: noteId ?? this.noteId,
      content: content ?? this.content,
      topics: topics ?? this.topics,
      revision: revision ?? this.revision,
      createdAt: createdAt ?? this.createdAt,
      deleted: deleted ?? this.deleted,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (topics.present) {
      map['topics'] = Variable<String>(topics.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalNotesTableCompanion(')
          ..write('noteId: $noteId, ')
          ..write('content: $content, ')
          ..write('topics: $topics, ')
          ..write('revision: $revision, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostRepliesTableTable extends PostRepliesTable
    with TableInfo<$PostRepliesTableTable, PostReply> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostRepliesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _replyIdMeta = const VerificationMeta(
    'replyId',
  );
  @override
  late final GeneratedColumn<String> replyId = GeneratedColumn<String>(
    'reply_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentReplyIdMeta = const VerificationMeta(
    'parentReplyId',
  );
  @override
  late final GeneratedColumn<String> parentReplyId = GeneratedColumn<String>(
    'parent_reply_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorUsernameMeta = const VerificationMeta(
    'authorUsername',
  );
  @override
  late final GeneratedColumn<String> authorUsername = GeneratedColumn<String>(
    'author_username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    replyId,
    postId,
    parentReplyId,
    authorId,
    authorUsername,
    content,
    createdAt,
    deleted,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'post_replies';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostReply> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('reply_id')) {
      context.handle(
        _replyIdMeta,
        replyId.isAcceptableOrUnknown(data['reply_id']!, _replyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_replyIdMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('parent_reply_id')) {
      context.handle(
        _parentReplyIdMeta,
        parentReplyId.isAcceptableOrUnknown(
          data['parent_reply_id']!,
          _parentReplyIdMeta,
        ),
      );
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_username')) {
      context.handle(
        _authorUsernameMeta,
        authorUsername.isAcceptableOrUnknown(
          data['author_username']!,
          _authorUsernameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorUsernameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {replyId};
  @override
  PostReply map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostReply(
      replyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_id'],
      )!,
      parentReplyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_reply_id'],
      ),
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      authorUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_username'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $PostRepliesTableTable createAlias(String alias) {
    return $PostRepliesTableTable(attachedDatabase, alias);
  }
}

class PostReply extends DataClass implements Insertable<PostReply> {
  final String replyId;
  final String postId;
  final String? parentReplyId;
  final String authorId;
  final String authorUsername;
  final String content;
  final DateTime createdAt;
  final bool deleted;
  final DateTime fetchedAt;
  const PostReply({
    required this.replyId,
    required this.postId,
    this.parentReplyId,
    required this.authorId,
    required this.authorUsername,
    required this.content,
    required this.createdAt,
    required this.deleted,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reply_id'] = Variable<String>(replyId);
    map['post_id'] = Variable<String>(postId);
    if (!nullToAbsent || parentReplyId != null) {
      map['parent_reply_id'] = Variable<String>(parentReplyId);
    }
    map['author_id'] = Variable<String>(authorId);
    map['author_username'] = Variable<String>(authorUsername);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['deleted'] = Variable<bool>(deleted);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  PostRepliesTableCompanion toCompanion(bool nullToAbsent) {
    return PostRepliesTableCompanion(
      replyId: Value(replyId),
      postId: Value(postId),
      parentReplyId: parentReplyId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentReplyId),
      authorId: Value(authorId),
      authorUsername: Value(authorUsername),
      content: Value(content),
      createdAt: Value(createdAt),
      deleted: Value(deleted),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory PostReply.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostReply(
      replyId: serializer.fromJson<String>(json['replyId']),
      postId: serializer.fromJson<String>(json['postId']),
      parentReplyId: serializer.fromJson<String?>(json['parentReplyId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorUsername: serializer.fromJson<String>(json['authorUsername']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'replyId': serializer.toJson<String>(replyId),
      'postId': serializer.toJson<String>(postId),
      'parentReplyId': serializer.toJson<String?>(parentReplyId),
      'authorId': serializer.toJson<String>(authorId),
      'authorUsername': serializer.toJson<String>(authorUsername),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deleted': serializer.toJson<bool>(deleted),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  PostReply copyWith({
    String? replyId,
    String? postId,
    Value<String?> parentReplyId = const Value.absent(),
    String? authorId,
    String? authorUsername,
    String? content,
    DateTime? createdAt,
    bool? deleted,
    DateTime? fetchedAt,
  }) => PostReply(
    replyId: replyId ?? this.replyId,
    postId: postId ?? this.postId,
    parentReplyId: parentReplyId.present
        ? parentReplyId.value
        : this.parentReplyId,
    authorId: authorId ?? this.authorId,
    authorUsername: authorUsername ?? this.authorUsername,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    deleted: deleted ?? this.deleted,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  PostReply copyWithCompanion(PostRepliesTableCompanion data) {
    return PostReply(
      replyId: data.replyId.present ? data.replyId.value : this.replyId,
      postId: data.postId.present ? data.postId.value : this.postId,
      parentReplyId: data.parentReplyId.present
          ? data.parentReplyId.value
          : this.parentReplyId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorUsername: data.authorUsername.present
          ? data.authorUsername.value
          : this.authorUsername,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostReply(')
          ..write('replyId: $replyId, ')
          ..write('postId: $postId, ')
          ..write('parentReplyId: $parentReplyId, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    replyId,
    postId,
    parentReplyId,
    authorId,
    authorUsername,
    content,
    createdAt,
    deleted,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostReply &&
          other.replyId == this.replyId &&
          other.postId == this.postId &&
          other.parentReplyId == this.parentReplyId &&
          other.authorId == this.authorId &&
          other.authorUsername == this.authorUsername &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.deleted == this.deleted &&
          other.fetchedAt == this.fetchedAt);
}

class PostRepliesTableCompanion extends UpdateCompanion<PostReply> {
  final Value<String> replyId;
  final Value<String> postId;
  final Value<String?> parentReplyId;
  final Value<String> authorId;
  final Value<String> authorUsername;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<bool> deleted;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const PostRepliesTableCompanion({
    this.replyId = const Value.absent(),
    this.postId = const Value.absent(),
    this.parentReplyId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorUsername = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostRepliesTableCompanion.insert({
    required String replyId,
    required String postId,
    this.parentReplyId = const Value.absent(),
    required String authorId,
    required String authorUsername,
    required String content,
    required DateTime createdAt,
    required bool deleted,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : replyId = Value(replyId),
       postId = Value(postId),
       authorId = Value(authorId),
       authorUsername = Value(authorUsername),
       content = Value(content),
       createdAt = Value(createdAt),
       deleted = Value(deleted),
       fetchedAt = Value(fetchedAt);
  static Insertable<PostReply> custom({
    Expression<String>? replyId,
    Expression<String>? postId,
    Expression<String>? parentReplyId,
    Expression<String>? authorId,
    Expression<String>? authorUsername,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<bool>? deleted,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (replyId != null) 'reply_id': replyId,
      if (postId != null) 'post_id': postId,
      if (parentReplyId != null) 'parent_reply_id': parentReplyId,
      if (authorId != null) 'author_id': authorId,
      if (authorUsername != null) 'author_username': authorUsername,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (deleted != null) 'deleted': deleted,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostRepliesTableCompanion copyWith({
    Value<String>? replyId,
    Value<String>? postId,
    Value<String?>? parentReplyId,
    Value<String>? authorId,
    Value<String>? authorUsername,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<bool>? deleted,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return PostRepliesTableCompanion(
      replyId: replyId ?? this.replyId,
      postId: postId ?? this.postId,
      parentReplyId: parentReplyId ?? this.parentReplyId,
      authorId: authorId ?? this.authorId,
      authorUsername: authorUsername ?? this.authorUsername,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      deleted: deleted ?? this.deleted,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (replyId.present) {
      map['reply_id'] = Variable<String>(replyId.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (parentReplyId.present) {
      map['parent_reply_id'] = Variable<String>(parentReplyId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorUsername.present) {
      map['author_username'] = Variable<String>(authorUsername.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostRepliesTableCompanion(')
          ..write('replyId: $replyId, ')
          ..write('postId: $postId, ')
          ..write('parentReplyId: $parentReplyId, ')
          ..write('authorId: $authorId, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('deleted: $deleted, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FeedPostsTableTable feedPostsTable = $FeedPostsTableTable(this);
  late final $BookmarkedPostsTableTable bookmarkedPostsTable =
      $BookmarkedPostsTableTable(this);
  late final $BookmarkedRepliesTableTable bookmarkedRepliesTable =
      $BookmarkedRepliesTableTable(this);
  late final $JournalNotesTableTable journalNotesTable =
      $JournalNotesTableTable(this);
  late final $PostRepliesTableTable postRepliesTable = $PostRepliesTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    feedPostsTable,
    bookmarkedPostsTable,
    bookmarkedRepliesTable,
    journalNotesTable,
    postRepliesTable,
  ];
}

typedef $$FeedPostsTableTableCreateCompanionBuilder =
    FeedPostsTableCompanion Function({
      required String postId,
      required String authorId,
      required String authorUsername,
      required String content,
      required String topics,
      required int repliesCount,
      required int bookmarksCount,
      required bool isPublic,
      required bool isNsfw,
      required String attachments,
      required bool hasAudioAttachment,
      required String audioAttachmentGenre,
      required DateTime createdAt,
      required bool deleted,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$FeedPostsTableTableUpdateCompanionBuilder =
    FeedPostsTableCompanion Function({
      Value<String> postId,
      Value<String> authorId,
      Value<String> authorUsername,
      Value<String> content,
      Value<String> topics,
      Value<int> repliesCount,
      Value<int> bookmarksCount,
      Value<bool> isPublic,
      Value<bool> isNsfw,
      Value<String> attachments,
      Value<bool> hasAudioAttachment,
      Value<String> audioAttachmentGenre,
      Value<DateTime> createdAt,
      Value<bool> deleted,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$FeedPostsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FeedPostsTableTable> {
  $$FeedPostsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topics => $composableBuilder(
    column: $table.topics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repliesCount => $composableBuilder(
    column: $table.repliesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookmarksCount => $composableBuilder(
    column: $table.bookmarksCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNsfw => $composableBuilder(
    column: $table.isNsfw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAudioAttachment => $composableBuilder(
    column: $table.hasAudioAttachment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioAttachmentGenre => $composableBuilder(
    column: $table.audioAttachmentGenre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeedPostsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedPostsTableTable> {
  $$FeedPostsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topics => $composableBuilder(
    column: $table.topics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repliesCount => $composableBuilder(
    column: $table.repliesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookmarksCount => $composableBuilder(
    column: $table.bookmarksCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNsfw => $composableBuilder(
    column: $table.isNsfw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAudioAttachment => $composableBuilder(
    column: $table.hasAudioAttachment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioAttachmentGenre => $composableBuilder(
    column: $table.audioAttachmentGenre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeedPostsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedPostsTableTable> {
  $$FeedPostsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get topics =>
      $composableBuilder(column: $table.topics, builder: (column) => column);

  GeneratedColumn<int> get repliesCount => $composableBuilder(
    column: $table.repliesCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bookmarksCount => $composableBuilder(
    column: $table.bookmarksCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<bool> get isNsfw =>
      $composableBuilder(column: $table.isNsfw, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasAudioAttachment => $composableBuilder(
    column: $table.hasAudioAttachment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioAttachmentGenre => $composableBuilder(
    column: $table.audioAttachmentGenre,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$FeedPostsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedPostsTableTable,
          FeedPost,
          $$FeedPostsTableTableFilterComposer,
          $$FeedPostsTableTableOrderingComposer,
          $$FeedPostsTableTableAnnotationComposer,
          $$FeedPostsTableTableCreateCompanionBuilder,
          $$FeedPostsTableTableUpdateCompanionBuilder,
          (
            FeedPost,
            BaseReferences<_$AppDatabase, $FeedPostsTableTable, FeedPost>,
          ),
          FeedPost,
          PrefetchHooks Function()
        > {
  $$FeedPostsTableTableTableManager(
    _$AppDatabase db,
    $FeedPostsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedPostsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedPostsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedPostsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> postId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> authorUsername = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> topics = const Value.absent(),
                Value<int> repliesCount = const Value.absent(),
                Value<int> bookmarksCount = const Value.absent(),
                Value<bool> isPublic = const Value.absent(),
                Value<bool> isNsfw = const Value.absent(),
                Value<String> attachments = const Value.absent(),
                Value<bool> hasAudioAttachment = const Value.absent(),
                Value<String> audioAttachmentGenre = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeedPostsTableCompanion(
                postId: postId,
                authorId: authorId,
                authorUsername: authorUsername,
                content: content,
                topics: topics,
                repliesCount: repliesCount,
                bookmarksCount: bookmarksCount,
                isPublic: isPublic,
                isNsfw: isNsfw,
                attachments: attachments,
                hasAudioAttachment: hasAudioAttachment,
                audioAttachmentGenre: audioAttachmentGenre,
                createdAt: createdAt,
                deleted: deleted,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String postId,
                required String authorId,
                required String authorUsername,
                required String content,
                required String topics,
                required int repliesCount,
                required int bookmarksCount,
                required bool isPublic,
                required bool isNsfw,
                required String attachments,
                required bool hasAudioAttachment,
                required String audioAttachmentGenre,
                required DateTime createdAt,
                required bool deleted,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => FeedPostsTableCompanion.insert(
                postId: postId,
                authorId: authorId,
                authorUsername: authorUsername,
                content: content,
                topics: topics,
                repliesCount: repliesCount,
                bookmarksCount: bookmarksCount,
                isPublic: isPublic,
                isNsfw: isNsfw,
                attachments: attachments,
                hasAudioAttachment: hasAudioAttachment,
                audioAttachmentGenre: audioAttachmentGenre,
                createdAt: createdAt,
                deleted: deleted,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeedPostsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedPostsTableTable,
      FeedPost,
      $$FeedPostsTableTableFilterComposer,
      $$FeedPostsTableTableOrderingComposer,
      $$FeedPostsTableTableAnnotationComposer,
      $$FeedPostsTableTableCreateCompanionBuilder,
      $$FeedPostsTableTableUpdateCompanionBuilder,
      (FeedPost, BaseReferences<_$AppDatabase, $FeedPostsTableTable, FeedPost>),
      FeedPost,
      PrefetchHooks Function()
    >;
typedef $$BookmarkedPostsTableTableCreateCompanionBuilder =
    BookmarkedPostsTableCompanion Function({
      required String bookmarkId,
      required String postId,
      required String authorId,
      required String authorUsername,
      required String content,
      required String topics,
      required int repliesCount,
      required int bookmarksCount,
      required bool isPublic,
      required bool isNsfw,
      required String attachments,
      required bool hasAudioAttachment,
      required String audioAttachmentGenre,
      required DateTime createdAt,
      required bool deleted,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$BookmarkedPostsTableTableUpdateCompanionBuilder =
    BookmarkedPostsTableCompanion Function({
      Value<String> bookmarkId,
      Value<String> postId,
      Value<String> authorId,
      Value<String> authorUsername,
      Value<String> content,
      Value<String> topics,
      Value<int> repliesCount,
      Value<int> bookmarksCount,
      Value<bool> isPublic,
      Value<bool> isNsfw,
      Value<String> attachments,
      Value<bool> hasAudioAttachment,
      Value<String> audioAttachmentGenre,
      Value<DateTime> createdAt,
      Value<bool> deleted,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$BookmarkedPostsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarkedPostsTableTable> {
  $$BookmarkedPostsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bookmarkId => $composableBuilder(
    column: $table.bookmarkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topics => $composableBuilder(
    column: $table.topics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repliesCount => $composableBuilder(
    column: $table.repliesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookmarksCount => $composableBuilder(
    column: $table.bookmarksCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNsfw => $composableBuilder(
    column: $table.isNsfw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAudioAttachment => $composableBuilder(
    column: $table.hasAudioAttachment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioAttachmentGenre => $composableBuilder(
    column: $table.audioAttachmentGenre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarkedPostsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarkedPostsTableTable> {
  $$BookmarkedPostsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bookmarkId => $composableBuilder(
    column: $table.bookmarkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topics => $composableBuilder(
    column: $table.topics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repliesCount => $composableBuilder(
    column: $table.repliesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookmarksCount => $composableBuilder(
    column: $table.bookmarksCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNsfw => $composableBuilder(
    column: $table.isNsfw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAudioAttachment => $composableBuilder(
    column: $table.hasAudioAttachment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioAttachmentGenre => $composableBuilder(
    column: $table.audioAttachmentGenre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarkedPostsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarkedPostsTableTable> {
  $$BookmarkedPostsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bookmarkId => $composableBuilder(
    column: $table.bookmarkId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get topics =>
      $composableBuilder(column: $table.topics, builder: (column) => column);

  GeneratedColumn<int> get repliesCount => $composableBuilder(
    column: $table.repliesCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bookmarksCount => $composableBuilder(
    column: $table.bookmarksCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<bool> get isNsfw =>
      $composableBuilder(column: $table.isNsfw, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasAudioAttachment => $composableBuilder(
    column: $table.hasAudioAttachment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioAttachmentGenre => $composableBuilder(
    column: $table.audioAttachmentGenre,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$BookmarkedPostsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarkedPostsTableTable,
          BookmarkedPost,
          $$BookmarkedPostsTableTableFilterComposer,
          $$BookmarkedPostsTableTableOrderingComposer,
          $$BookmarkedPostsTableTableAnnotationComposer,
          $$BookmarkedPostsTableTableCreateCompanionBuilder,
          $$BookmarkedPostsTableTableUpdateCompanionBuilder,
          (
            BookmarkedPost,
            BaseReferences<
              _$AppDatabase,
              $BookmarkedPostsTableTable,
              BookmarkedPost
            >,
          ),
          BookmarkedPost,
          PrefetchHooks Function()
        > {
  $$BookmarkedPostsTableTableTableManager(
    _$AppDatabase db,
    $BookmarkedPostsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarkedPostsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarkedPostsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BookmarkedPostsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> bookmarkId = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> authorUsername = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> topics = const Value.absent(),
                Value<int> repliesCount = const Value.absent(),
                Value<int> bookmarksCount = const Value.absent(),
                Value<bool> isPublic = const Value.absent(),
                Value<bool> isNsfw = const Value.absent(),
                Value<String> attachments = const Value.absent(),
                Value<bool> hasAudioAttachment = const Value.absent(),
                Value<String> audioAttachmentGenre = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarkedPostsTableCompanion(
                bookmarkId: bookmarkId,
                postId: postId,
                authorId: authorId,
                authorUsername: authorUsername,
                content: content,
                topics: topics,
                repliesCount: repliesCount,
                bookmarksCount: bookmarksCount,
                isPublic: isPublic,
                isNsfw: isNsfw,
                attachments: attachments,
                hasAudioAttachment: hasAudioAttachment,
                audioAttachmentGenre: audioAttachmentGenre,
                createdAt: createdAt,
                deleted: deleted,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bookmarkId,
                required String postId,
                required String authorId,
                required String authorUsername,
                required String content,
                required String topics,
                required int repliesCount,
                required int bookmarksCount,
                required bool isPublic,
                required bool isNsfw,
                required String attachments,
                required bool hasAudioAttachment,
                required String audioAttachmentGenre,
                required DateTime createdAt,
                required bool deleted,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => BookmarkedPostsTableCompanion.insert(
                bookmarkId: bookmarkId,
                postId: postId,
                authorId: authorId,
                authorUsername: authorUsername,
                content: content,
                topics: topics,
                repliesCount: repliesCount,
                bookmarksCount: bookmarksCount,
                isPublic: isPublic,
                isNsfw: isNsfw,
                attachments: attachments,
                hasAudioAttachment: hasAudioAttachment,
                audioAttachmentGenre: audioAttachmentGenre,
                createdAt: createdAt,
                deleted: deleted,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarkedPostsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarkedPostsTableTable,
      BookmarkedPost,
      $$BookmarkedPostsTableTableFilterComposer,
      $$BookmarkedPostsTableTableOrderingComposer,
      $$BookmarkedPostsTableTableAnnotationComposer,
      $$BookmarkedPostsTableTableCreateCompanionBuilder,
      $$BookmarkedPostsTableTableUpdateCompanionBuilder,
      (
        BookmarkedPost,
        BaseReferences<
          _$AppDatabase,
          $BookmarkedPostsTableTable,
          BookmarkedPost
        >,
      ),
      BookmarkedPost,
      PrefetchHooks Function()
    >;
typedef $$BookmarkedRepliesTableTableCreateCompanionBuilder =
    BookmarkedRepliesTableCompanion Function({
      required String bookmarkId,
      required String replyId,
      required String postId,
      Value<String?> parentReplyId,
      required String authorId,
      required String authorUsername,
      required String content,
      required DateTime createdAt,
      required bool deleted,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$BookmarkedRepliesTableTableUpdateCompanionBuilder =
    BookmarkedRepliesTableCompanion Function({
      Value<String> bookmarkId,
      Value<String> replyId,
      Value<String> postId,
      Value<String?> parentReplyId,
      Value<String> authorId,
      Value<String> authorUsername,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<bool> deleted,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$BookmarkedRepliesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarkedRepliesTableTable> {
  $$BookmarkedRepliesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bookmarkId => $composableBuilder(
    column: $table.bookmarkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyId => $composableBuilder(
    column: $table.replyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentReplyId => $composableBuilder(
    column: $table.parentReplyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarkedRepliesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarkedRepliesTableTable> {
  $$BookmarkedRepliesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bookmarkId => $composableBuilder(
    column: $table.bookmarkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyId => $composableBuilder(
    column: $table.replyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentReplyId => $composableBuilder(
    column: $table.parentReplyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarkedRepliesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarkedRepliesTableTable> {
  $$BookmarkedRepliesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bookmarkId => $composableBuilder(
    column: $table.bookmarkId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replyId =>
      $composableBuilder(column: $table.replyId, builder: (column) => column);

  GeneratedColumn<String> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get parentReplyId => $composableBuilder(
    column: $table.parentReplyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$BookmarkedRepliesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarkedRepliesTableTable,
          BookmarkedReply,
          $$BookmarkedRepliesTableTableFilterComposer,
          $$BookmarkedRepliesTableTableOrderingComposer,
          $$BookmarkedRepliesTableTableAnnotationComposer,
          $$BookmarkedRepliesTableTableCreateCompanionBuilder,
          $$BookmarkedRepliesTableTableUpdateCompanionBuilder,
          (
            BookmarkedReply,
            BaseReferences<
              _$AppDatabase,
              $BookmarkedRepliesTableTable,
              BookmarkedReply
            >,
          ),
          BookmarkedReply,
          PrefetchHooks Function()
        > {
  $$BookmarkedRepliesTableTableTableManager(
    _$AppDatabase db,
    $BookmarkedRepliesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarkedRepliesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BookmarkedRepliesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BookmarkedRepliesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> bookmarkId = const Value.absent(),
                Value<String> replyId = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<String?> parentReplyId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> authorUsername = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarkedRepliesTableCompanion(
                bookmarkId: bookmarkId,
                replyId: replyId,
                postId: postId,
                parentReplyId: parentReplyId,
                authorId: authorId,
                authorUsername: authorUsername,
                content: content,
                createdAt: createdAt,
                deleted: deleted,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bookmarkId,
                required String replyId,
                required String postId,
                Value<String?> parentReplyId = const Value.absent(),
                required String authorId,
                required String authorUsername,
                required String content,
                required DateTime createdAt,
                required bool deleted,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => BookmarkedRepliesTableCompanion.insert(
                bookmarkId: bookmarkId,
                replyId: replyId,
                postId: postId,
                parentReplyId: parentReplyId,
                authorId: authorId,
                authorUsername: authorUsername,
                content: content,
                createdAt: createdAt,
                deleted: deleted,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarkedRepliesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarkedRepliesTableTable,
      BookmarkedReply,
      $$BookmarkedRepliesTableTableFilterComposer,
      $$BookmarkedRepliesTableTableOrderingComposer,
      $$BookmarkedRepliesTableTableAnnotationComposer,
      $$BookmarkedRepliesTableTableCreateCompanionBuilder,
      $$BookmarkedRepliesTableTableUpdateCompanionBuilder,
      (
        BookmarkedReply,
        BaseReferences<
          _$AppDatabase,
          $BookmarkedRepliesTableTable,
          BookmarkedReply
        >,
      ),
      BookmarkedReply,
      PrefetchHooks Function()
    >;
typedef $$JournalNotesTableTableCreateCompanionBuilder =
    JournalNotesTableCompanion Function({
      required String noteId,
      required String content,
      required String topics,
      required int revision,
      Value<DateTime?> createdAt,
      required bool deleted,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$JournalNotesTableTableUpdateCompanionBuilder =
    JournalNotesTableCompanion Function({
      Value<String> noteId,
      Value<String> content,
      Value<String> topics,
      Value<int> revision,
      Value<DateTime?> createdAt,
      Value<bool> deleted,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$JournalNotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $JournalNotesTableTable> {
  $$JournalNotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topics => $composableBuilder(
    column: $table.topics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalNotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalNotesTableTable> {
  $$JournalNotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topics => $composableBuilder(
    column: $table.topics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalNotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalNotesTableTable> {
  $$JournalNotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get topics =>
      $composableBuilder(column: $table.topics, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$JournalNotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalNotesTableTable,
          JournalNote,
          $$JournalNotesTableTableFilterComposer,
          $$JournalNotesTableTableOrderingComposer,
          $$JournalNotesTableTableAnnotationComposer,
          $$JournalNotesTableTableCreateCompanionBuilder,
          $$JournalNotesTableTableUpdateCompanionBuilder,
          (
            JournalNote,
            BaseReferences<_$AppDatabase, $JournalNotesTableTable, JournalNote>,
          ),
          JournalNote,
          PrefetchHooks Function()
        > {
  $$JournalNotesTableTableTableManager(
    _$AppDatabase db,
    $JournalNotesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalNotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalNotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalNotesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> noteId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> topics = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalNotesTableCompanion(
                noteId: noteId,
                content: content,
                topics: topics,
                revision: revision,
                createdAt: createdAt,
                deleted: deleted,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String noteId,
                required String content,
                required String topics,
                required int revision,
                Value<DateTime?> createdAt = const Value.absent(),
                required bool deleted,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => JournalNotesTableCompanion.insert(
                noteId: noteId,
                content: content,
                topics: topics,
                revision: revision,
                createdAt: createdAt,
                deleted: deleted,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalNotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalNotesTableTable,
      JournalNote,
      $$JournalNotesTableTableFilterComposer,
      $$JournalNotesTableTableOrderingComposer,
      $$JournalNotesTableTableAnnotationComposer,
      $$JournalNotesTableTableCreateCompanionBuilder,
      $$JournalNotesTableTableUpdateCompanionBuilder,
      (
        JournalNote,
        BaseReferences<_$AppDatabase, $JournalNotesTableTable, JournalNote>,
      ),
      JournalNote,
      PrefetchHooks Function()
    >;
typedef $$PostRepliesTableTableCreateCompanionBuilder =
    PostRepliesTableCompanion Function({
      required String replyId,
      required String postId,
      Value<String?> parentReplyId,
      required String authorId,
      required String authorUsername,
      required String content,
      required DateTime createdAt,
      required bool deleted,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$PostRepliesTableTableUpdateCompanionBuilder =
    PostRepliesTableCompanion Function({
      Value<String> replyId,
      Value<String> postId,
      Value<String?> parentReplyId,
      Value<String> authorId,
      Value<String> authorUsername,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<bool> deleted,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$PostRepliesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PostRepliesTableTable> {
  $$PostRepliesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get replyId => $composableBuilder(
    column: $table.replyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentReplyId => $composableBuilder(
    column: $table.parentReplyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PostRepliesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PostRepliesTableTable> {
  $$PostRepliesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get replyId => $composableBuilder(
    column: $table.replyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postId => $composableBuilder(
    column: $table.postId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentReplyId => $composableBuilder(
    column: $table.parentReplyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PostRepliesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PostRepliesTableTable> {
  $$PostRepliesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get replyId =>
      $composableBuilder(column: $table.replyId, builder: (column) => column);

  GeneratedColumn<String> get postId =>
      $composableBuilder(column: $table.postId, builder: (column) => column);

  GeneratedColumn<String> get parentReplyId => $composableBuilder(
    column: $table.parentReplyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorUsername => $composableBuilder(
    column: $table.authorUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$PostRepliesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostRepliesTableTable,
          PostReply,
          $$PostRepliesTableTableFilterComposer,
          $$PostRepliesTableTableOrderingComposer,
          $$PostRepliesTableTableAnnotationComposer,
          $$PostRepliesTableTableCreateCompanionBuilder,
          $$PostRepliesTableTableUpdateCompanionBuilder,
          (
            PostReply,
            BaseReferences<_$AppDatabase, $PostRepliesTableTable, PostReply>,
          ),
          PostReply,
          PrefetchHooks Function()
        > {
  $$PostRepliesTableTableTableManager(
    _$AppDatabase db,
    $PostRepliesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostRepliesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostRepliesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostRepliesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> replyId = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<String?> parentReplyId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> authorUsername = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostRepliesTableCompanion(
                replyId: replyId,
                postId: postId,
                parentReplyId: parentReplyId,
                authorId: authorId,
                authorUsername: authorUsername,
                content: content,
                createdAt: createdAt,
                deleted: deleted,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String replyId,
                required String postId,
                Value<String?> parentReplyId = const Value.absent(),
                required String authorId,
                required String authorUsername,
                required String content,
                required DateTime createdAt,
                required bool deleted,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => PostRepliesTableCompanion.insert(
                replyId: replyId,
                postId: postId,
                parentReplyId: parentReplyId,
                authorId: authorId,
                authorUsername: authorUsername,
                content: content,
                createdAt: createdAt,
                deleted: deleted,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PostRepliesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostRepliesTableTable,
      PostReply,
      $$PostRepliesTableTableFilterComposer,
      $$PostRepliesTableTableOrderingComposer,
      $$PostRepliesTableTableAnnotationComposer,
      $$PostRepliesTableTableCreateCompanionBuilder,
      $$PostRepliesTableTableUpdateCompanionBuilder,
      (
        PostReply,
        BaseReferences<_$AppDatabase, $PostRepliesTableTable, PostReply>,
      ),
      PostReply,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FeedPostsTableTableTableManager get feedPostsTable =>
      $$FeedPostsTableTableTableManager(_db, _db.feedPostsTable);
  $$BookmarkedPostsTableTableTableManager get bookmarkedPostsTable =>
      $$BookmarkedPostsTableTableTableManager(_db, _db.bookmarkedPostsTable);
  $$BookmarkedRepliesTableTableTableManager get bookmarkedRepliesTable =>
      $$BookmarkedRepliesTableTableTableManager(
        _db,
        _db.bookmarkedRepliesTable,
      );
  $$JournalNotesTableTableTableManager get journalNotesTable =>
      $$JournalNotesTableTableTableManager(_db, _db.journalNotesTable);
  $$PostRepliesTableTableTableManager get postRepliesTable =>
      $$PostRepliesTableTableTableManager(_db, _db.postRepliesTable);
}
