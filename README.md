# Crisp Wiki

[![](https://img.shields.io/badge/powered%20by-jekyll-red.svg)](https://jekyllrb.com)
[![](https://api.travis-ci.org/crispgm/crispgm.github.io.svg)](https://travis-ci.org/crispgm/crispgm.github.io)
![](https://stars-badge.herokuapp.com/crispgm/weekly/last-pages-build.svg)

Personal curation of tech articles.

## Install

1. Clone

    ```
    $ git clone https://github.com/crispgm/crispgm.github.io.git
    ```

2. Bundler

    ```
    $ bundle install
    ```

3. Run

    ```
    $ rake serve
    ```

## Folder Structure

* Weekly posts are in `_posts/`
* Weekly newsletters are in `_newsletter/`

```
_posts/
    2016-09-06-weekly.md
    ...
_newsletter/
    2016-09-06-weekly-email.md
    ...
```

## `rake` Commands

### Create Weekly

```
$ rake weekly:create
```

It will generate scaffolds with date:

```
_weekly/2016-10-09-weekly.md
_newsletter/2016-10-09-weekly-email.md
```

To specify date:

```
$ rake weekly:create[2016-10-09]
```

P.S. In `zsh`, we need to use backslash escape:

```
$ rake weekly:create\[2016-10-09\]
```

### Create GitHub Issue

```
$ ACCESS_TOKEN=your-access-token-here rake weekly:open[2016-10-09]
```

### Import Articles From GitHub Issue

```
$ ACCESS_TOKEN=your-access-token-here rake weekly:import[2016-10-09]
```

### Edit Weekly

Open and edit the latest entry:

```
$ rake weekly:edit-latest
```

To use non-default editors, pass an env variable to `rake`:

```
$ EDITOR=subl rake weekly:edit-latest
```
### YAML Format

| Field | Type |
|------|-----|
| title | String (Support inline html) |
| link | String |
| comment | String (Support inline html) |

### Tests

There are several tests to check typos and duplicates errors.

```
$ rake test-weekly
```

It scan all weeklys by default, to specify date:

```
$ rake test-weekly[2016-11-15]
```

For the latest weekly, pass `latest`:

```
$ rake test-weekly[latest]
```

Errors will show with highlighted message to indicates the item:

```
[ERROR] Duplicated name within a weekly found:
    Filename: 2016-11-22-weekly.md
        Item: 1
     >> Name: Google 是如何做到从不宕机的
```

## Content Source

- [Wanqu](https://wanqu.co/)
- [掘金](https://juejin.im/)

## License

MIT
