from .common import InfoExtractor

class AnimediaTVIE(InfoExtractor):
    _VALID_URL = r'(?:https?://)?(?:www\.)?online.animedia.tv/anime/(?P<id>[-\w/]+)'

    def _real_extract(self, url):
        video_id = self._match_id(url)
        s, p = video_id.split('/')[1:]
        webpage = self._download_webpage(url, video_id)
        self.report_extraction(video_id)
        embed_id = self._html_search_regex(r'<input type="hidden" name="entry_id" value="(.+?)"', webpage, video_id)
        video_url = 'https://online.animedia.tv/embed/{}/{}/{}'.format(embed_id, s, p)

        return self.url_result(video_url, video_id=video_id, video_title=video_id.replace('/', '-'))
