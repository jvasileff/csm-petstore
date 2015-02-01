import org.springframework.web.servlet.view {
    RedirectView
}

RedirectView redirect(String url)
    =>  RedirectView(url, true);