from .common import InfoExtractor
from urllib import parse
import re, json, sys, base64
from lxml import etree


class AnimediaIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?online\.animedia\.tv/anime/(?P<id>[-\w/]+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)

        groups = re.search(r'file:\s*"(https?://online.animedia.tv/embeds/playlist-j\.txt/[^"]+)",\s*plstart:\s*"([^"]+)"', webpage)
        playlist, series = groups[1], groups[2]

        lst = json.loads(self._download_webpage(playlist, playlist))
        for x in lst:
            if x['id'] == series:
                video_url = 'http:' + x['file'] if x['file'].startswith('//') else x['file']
                video_title = '{} - {}'.format(video_id, x['title'])
                video_id = x['id']
                break

        self.report_extraction(video_url)
        return {'id': video_id, 'title': video_title, 'url': video_url}


class GetPlrIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?(?:getplr\.xyz|getvi\.tv|onvi\.cc|secvideo1\.online)/embed/(?P<id>\d+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)

        video_urls = self._html_search_regex(r'file:\s*"([^"]+)"', webpage, video_id)
        self.report_extraction(video_urls)

        formats = []
        for g in re.split(',', video_urls):
            xs = re.search(r'\[(\d+)p?\](.+)', g)
            formats.append({'url': xs[2], 'quality': int(xs[1])})

        return {'id': video_id, 'title': video_id, 'formats': formats}


class KodikListIE(InfoExtractor):
    _VALID_URL = r'(?P<domain>(?:https?://)?(?:www\.)?(kodik\.info|aniqit\.com|anivod\.com))/(?P<type>(serial?|video|uv))/(?P<id>[-\w/]+)'
    _decode_table = {
            **{c: c + 13 if c < ord('N') else c - 13 for c in range(ord('A'), ord('Z') + 1)},
            **{c: c + 13 if c < ord('n') else c - 13 for c in range(ord('a'), ord('z') + 1)}}

    @staticmethod
    def __decode(data):
        decoded = base64.b64decode(data.translate(__class__._decode_table))
        return re.sub(r'^//', 'https://', decoded.decode())

    def __getter(self, domain, video_type, item):
        video_id = item.get('data-id')
        video_hash = item.get('data-hash')
        video_value = item.get('value')

        params = {'type': video_type, 'id': video_id, 'hash': video_hash}
        formdata = parse.urlencode(params).encode()
        webpage = self._download_webpage(f"{domain}/gvi", "Kodik GetVideoInfo", data=formdata)

        jsn = json.loads(webpage)
        result = {'id': video_id, 'title': f"#{video_value} ({video_id})", 'episode_number': int(video_value)}
        if 'link' in jsn:
            result.update({'url': jsn['link'], 'protocol': 'm3u8'})
        else:
            video_urls = jsn['links']
            formats = [{'url': self.__decode(v[0]['src']), 'quality': int(k)} for (k,v) in video_urls.items()]
            result.update({'formats': formats})

        return result

    def _real_extract(self, url):
        video_id = self._match_id(url)
        domain = re.search(self._VALID_URL, url).group('domain')
        video_type = re.search(self._VALID_URL, url).group('type')
        if video_type == 'serial':
            video_type = video_type[:-1]

        webpage = self._download_webpage(url, video_id, headers={'referer': domain})
        t = etree.HTML(webpage)
        title = t.xpath("//title/text()")[0]
        items = t.xpath("//div[@class='serial-series-box']/*/option")

        self.report_extraction(title)
        return {'_type': 'playlist', 'id': video_id, 'title': title, 'entries': map(lambda x: self.__getter(domain, video_type, x), items)}


class RoomfishIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?play\.roomfish\.ru/(?P<id>\d+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id, headers={'User-Agent': 'curl/7.67.0'})

        groups = re.search(r'"file":"([^"]+)"', webpage)[1].split(',')
        formats = []
        for g in groups:
            xs = re.search(r'\[\w+\s*\((\d+)\w\)\]([^\s]+)', g)
            formats.append({'url': xs[2], 'quality': int(xs[1])})

        return {'id': video_id, 'title': video_id, 'formats': formats}


class ZombieIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?api\d+\.delivembed\.cc/embed/movie/(?P<id>\d+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)
        video_json = self._html_search_regex(r'hlsList:\s*({[^}]+})', webpage, video_id)
        video_urls = json.loads(video_json)
        formats = [{'url': v, 'quality': int(k), 'protocol': 'm3u8'} for (k, v) in video_urls.items()]
        episode = re.search("[^&]*&(.*)", url)[1]

        return {'id': video_id, 'title': video_id + episode, 'formats': formats}


class SibnetIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?video\.sibnet\.ru/(?P<id>.+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)
        src = self._html_search_regex(r'src:\s*"([^"]+)', webpage, video_id)
        video_url = "https://video.sibnet.ru" + src
        self.report_extraction(video_url)
        formats = [{'url': video_url, 'http_headers': {'Referer': url}}]
        title = self._og_search_title(webpage)

        return {'id': video_id, 'title': title, 'formats': formats}


class YaDiskIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?yadi\.sk/i/(?P<id>.+)'
    _JSON_RE = r'(?is)<script[^>]+type=(["\']?)application/json\1[^>]+>(?P<json>.+?)</script>'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)
        video_json = json.loads(self._html_search_regex(self._JSON_RE, webpage, video_id, group='json'))
        resource = video_json['resources'][video_json['rootResourceId']]
        title = resource['name']
        formats = []
        for video in resource['videoStreams']['videos']:
            if video['dimension'] == 'adaptive':
                formats = [{'url': video['url']}]
                break
            else:
                formats.append({'url': video['url'], 'quality': int(video['dimension'][:-1])})

        self.report_extraction(formats[0])

        return {'id': video_id, 'title': title, 'formats': formats}

class HovelsIE(InfoExtractor):
    _VALID_URL = r'(?P<domain>(?:https?://)?(?:www\.)?hovels\.info)/bug/(?P<id>.+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        domain = re.search(self._VALID_URL, url).group('domain')
        webpage = self._download_webpage(url, video_id, headers={'referer': domain})

        config_json = self._html_search_regex(r'data-config=\'([^\']+)', webpage, video_id)
        video_url = json.loads(config_json)['hls']
        self.report_extraction(video_url)
        formats = [{'url': video_url, 'http_headers': {'Referer': url}}]
        return {'id': video_id, 'title': video_id, 'url': video_url}


class PlayerjsIE(InfoExtractor):
    _VALID_URL = r'(?P<domain>(?:https?://)?(?:www\.)?[^/]+)/iplayer/player\.php\?id=(?P<id>.+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        video_id = parse.parse_qs(parse.urlparse(url).query)['id'][0]
        video_id = parse.unquote(base64.b64decode(video_id))
        if video_id.startswith('//'):
            new_url = 'https:' + video_id
            webpage = self._download_webpage(new_url, video_id, headers={'referer': url})
            video_url = self._html_search_regex(r'file:\s*"([^"]+)"', webpage, video_id)
            self.report_extraction(video_url)
            return {'id': video_id, 'title': video_id, 'url': video_url}
        else:
            domain = re.search(self._VALID_URL, url).group('domain')
            new_url = domain + video_id
            webpage = self._download_webpage(new_url, video_id, headers={'referer': url})

            video_urls = self._html_search_regex(r'"file":\s*"([^"]+)"', webpage, video_id)
            self.report_extraction(video_urls)

            formats = []
            for g in re.split(',', video_urls):
                xs = re.search(r'\[(\d+)p?\](.+)', g)
                formats.append({'url': xs[2], 'quality': int(xs[1])})

            desc = self._html_search_meta('description', webpage, fatal=True)
            return {'id': video_id, 'title': desc, 'formats': formats}
