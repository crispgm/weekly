# [Crisp Minimal Weekly](https://crispgm.github.io/weekly/)

![GitHub CI](https://github.com/crispgm/weekly/workflows/build/badge.svg)
[![](https://img.shields.io/badge/powered%20by-jekyll-blue.svg)](https://jekyllrb.com)
![](https://stars-badge.herokuapp.com/crispgm/weekly/last-pages-build.svg)

Personal curation of tech articles. The articles are mostly English and the comments are in Chinese.
Started as a weekly, and now it is without certain interval.

## Install

1. Clone

    ```
    $ git clone https://github.com/crispgm/weekly.git
    ```

2. Bundler

    ```
    $ bundle install
    ```

3. Run

    ```
    $ rake serve
    ```

## Deliver Articles

To deliver articles, please leave comment to [issue](https://github.com/crispgm/weekly/issues) with specific format:

```
/post
- Your awesome title
- https://your-awesome.com/link-to-article.html
- Why you recommend the article in short.
```

### Format Specification

| Field | Type |
|------|-----|
| title | String (Support inline html) |
| link | String |
| comment | String (Support inline html) |

## Work with `rake`

### Create Weekly

```
$ rake weekly:create
```

It will generate scaffolds with date:

```
_weekly/2016-10-09-weekly.md
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

## Press

- [How I build engineering weekly automatically](https://crispgm.com/page/engineering-weekly-automation.html) (In Chinese)

## License

MIT
