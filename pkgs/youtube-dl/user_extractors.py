from .common import InfoExtractor
from urllib import parse
import re, json, sys


class AnimediaIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?online.animedia.tv/anime/(?P<id>[-\w/]+)'

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
    _VALID_URL = r'(?:https?://)?(?:www\.)?(?:getplr.xyz|getvi.tv|onvi.cc|secvideo1.online)/embed/(?P<id>\d+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)

        video_urls = self._html_search_regex(r'file:\s*"([^"]+)"', webpage, video_id)
        video_url = re.split(r',', video_urls)[0]

        self.report_extraction(video_url)
        return {'id': video_id, 'title': 'getplr ', 'url': re.sub(r'^\[\d+p?\]', '', video_url)}


class KodikIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?(kodik.info|aniqit.com)/go/seria/(?P<id>[-\w/]+)'

    def _real_extract(self, url):
        video_id, video_hash = self._match_id(url).split('/')[0:2]
        params = dict(parse.parse_qsl(parse.urlsplit(url).query))
        params.update({'type': 'seria', 'id': video_id, 'hash': video_hash, 'hash2': 'OErmnYyYA4wHwOP'})
        formdata = parse.urlencode(params).encode()
        webpage = self._download_webpage("https://kodik.info/video-links", video_id, data=formdata)
        jsn = json.loads(webpage)
        if 'link' in jsn:
            return {'id': video_id, 'title': video_hash, 'url': jsn['link'], 'protocol': 'm3u8'}
        else:
            video_urls = jsn['links']
            formats = [{'url': re.sub(r'^//', 'https://', v[0]['src']), 'quality': int(k)} for (k,v) in video_urls.items()]
            return {'id': video_id, 'title': video_hash, 'formats': formats}


class RoomfishIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?play.roomfish.ru/(?P<id>\d+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id, headers={'User-Agent': 'curl/7.67.0'})

        groups = re.search(r'"file":"([^"]+)"', webpage)[1].split(',')
        formats = []
        for g in groups:
            xs = re.search(r'\[\w+\s*\((\d+)\w\)\]([^\s]+)', g)
            formats.append({'url': xs[2], 'quality': int(xs[1])})

        return {'id': video_id, 'title': video_id, 'formats': formats}
