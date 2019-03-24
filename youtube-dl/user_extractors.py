from .common import InfoExtractor
import re

class AnimediaIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?online.animedia.tv/anime/(?P<id>[-\w/]+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)

        video_uuid = re.search(r'.+?/screens/(\w+).jpg', self._og_search_thumbnail(webpage)).group(1)
        embed_id = self._html_search_regex(r'(cdn-\d+.animedia.tv/[^/]+/{})'.format(video_uuid), webpage, video_id)
        video_url = 'https://{}.mp4/master.m3u8'.format(embed_id)
        self.report_extraction(video_url)

        return self.url_result(video_url, video_id=video_id, video_title=video_id.replace('/', '-'))
