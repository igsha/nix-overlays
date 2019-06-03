from .common import InfoExtractor
import re, json

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
                video_url = 'https:{}'.format(x['file'])
                video_title = '{} - {}'.format(video_id, x['title'])
                video_id = x['id']
                break

        self.report_extraction(video_url)
        return {'id': video_id, 'title': video_title, 'url': video_url}

class GetPlrIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?(?:getplr.xyz|getvi.tv|onvi.cc)/embed/(?P<id>\d+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)

        video_urls = self._html_search_regex(r'file:\s*"([^"]+)"', webpage, video_id)
        video_url = re.split(r',', video_urls)[0]

        self.report_extraction(video_url)
        return {'id': video_id, 'title': 'getplr ', 'url': re.sub(r'^\[\d+p?\]', '', video_url)}
