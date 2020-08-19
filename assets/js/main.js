// Avoid weird jumping of page in Chrome on reload. Due to the fixed header
// and images loading potentially slow the browser gets confused about how
// long the page is (in pixels) and auto-scrolls too far.
if ('scrollRestoration' in history) {
    history.scrollRestoration = 'manual';
}

(function(video) {
    if (!video) {
        return;
    }
    if (matchMedia('(prefers-reduced-motion)').matches) {
        return;
    }
    if (matchMedia(video.getAttribute('data-small-media')).matches) {
        video.src = video.getAttribute('data-small-src');
    }
    video.autoplay = true;
    video.addEventListener('play', function () {
        video.parentNode.classList.add('play-video');
    });
})(document.querySelector('#start-video'));