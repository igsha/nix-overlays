from .common import InfoExtractor
import re

class AnimediaIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?online.animedia.tv/anime/(?P<id>[-\w/]+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        webpage = self._download_webpage(url, video_id)

        entry_id = self._html_search_regex(r'data-id=(?:"|\')(\d+)', webpage, name=video_id)
        video_url_format = self._html_search_regex(r'<meta\s+property=(?:"|\')og:video(?:"|\')\s+href=(?:"|\')([^"\']+)', webpage, name=video_id)
        video_url = video_url_format.format(entry_id=entry_id)
        self.report_extraction(video_url)

        return self.url_result(video_url, video_id=video_id, video_title=video_id.replace('/', '-'))
