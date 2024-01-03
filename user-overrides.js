/****************************************************************************
 * SECTION: FASTFOX                                                         *
****************************************************************************/
user_pref("image.jxl.enabled", true);
user_pref("layout.css.grid-template-masonry-value.enabled", true);
user_pref("dom.enable_web_task_scheduling", true);
user_pref("gfx.offscreencanvas.enabled", true);
user_pref("layout.css.font-loading-api.workers.enabled", true);
user_pref("layout.css.animation-composition.enabled", true);
user_pref("dom.importMaps.enabled", true);
user_pref("gfx.webrender.all",true);
user_pref("network.http.max-persistent-connections-per-server",16);

/** DISK AVOIDANCE ***/
user_pref("browser.cache.disk.enable", true);
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("media.memory_cache_max_size", 65536);
user_pref("browser.sessionstore.privacy_level", 0);
user_pref("browser.pagethumbnails.capturing_disabled", true);

/** SHUTDOWN & SANITIZING ***/
user_pref("privacy.history.custom", true);

/** SPECULATIVE CONNECTIONS ***/
user_pref("network.http.speculative-parallel-limit", 6);
user_pref("network.dns.disablePrefetch", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("network.prefetch-next", true);
user_pref("network.predictor.enabled", true);
user_pref("network.predictor.enable-prefetch", true);

/** MEDIA ***/
user_pref("media.ffmpeg.vaapi.enabled", true);

/****************************************************************************
 * SECTION: SECUREFOX                                                       *
****************************************************************************/
/** TRACKING PROTECTION ***/
user_pref("browser.contentblocking.category", "standard");
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.query_stripping.strip_list", "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid");
user_pref("urlclassifier.trackingSkipURLs", "*.reddit.com, *.twitter.com, *.twimg.com");
user_pref("urlclassifier.features.socialtracking.skipURLs", "*.instagram.com, *.twitter.com, *.twimg.com");
user_pref("privacy.partition.always_partition_third_party_non_cookie_storage", true);
user_pref("privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage", false);
user_pref("beacon.enabled", false);

/** OCSP & CERTS / HPKP ***/
user_pref("security.OCSP.enabled", 0);
user_pref("security.remote_settings.crlite_filters.enabled", true);
user_pref("security.pki.crlite_mode", 2);
user_pref("security.cert_pinning.enforcement_level", 2);

/** SSL / TLS ***/
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);
user_pref("security.tls.enable_0rtt_data", false);

/** FONTS ***/
user_pref("layout.css.font-visibility.private", 1);
user_pref("layout.css.font-visibility.trackingprotection", 1);

/** SEARCH / URL BAR ***/
user_pref("browser.search.separatePrivateDefault", true);
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
user_pref("browser.urlbar.update2.engineAliasRefresh", true);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("network.IDN_show_punycode", true);

/** HTTPS-ONLY MODE ***/
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);

/** DNS-over-HTTPS (DOH) ***/
user_pref("network.dns.skipTRR-when-parental-control-enabled", false);

/** PROXY / SOCKS / IPv6 ***/
user_pref("network.proxy.socks_remote_dns", true);
user_pref("network.file.disable_unc_paths", true);
user_pref("network.gio.supported-protocols", "");

/** PASSWORDS AND AUTOFILL ***/
user_pref("signon.formlessCapture.enabled", false);
user_pref("signon.privateBrowsingCapture.enabled", false);
user_pref("signon.autofillForms", false);
user_pref("signon.rememberSignons", false);
user_pref("editor.truncate_user_pastes", false);
user_pref("layout.forms.reveal-password-button.enabled", true);

/** ADDRESS + CREDIT CARD MANAGER ***/
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.formautofill.heuristics.enabled", false);
user_pref("browser.formfill.enable", false);

/** MIXED CONTENT + CROSS-SITE ***/
user_pref("network.auth.subresource-http-auth-allow", 1);
user_pref("pdfjs.enableScripting", false);
user_pref("extensions.postDownloadThirdPartyPrompt", false);
user_pref("permissions.delegation.enabled", false);

/** HEADERS / REFERERS ***/
user_pref("network.http.referer.defaultPolicy.trackers", 1);
user_pref("network.http.referer.defaultPolicy.trackers.pbmode", 1);
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

/** CONTAINERS ***/
user_pref("privacy.userContext.ui.enabled", true);

/** WEBRTC ***/
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
user_pref("media.peerconnection.ice.default_address_only", true);

/** GOOGLE SAFE BROWSING ***/
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
user_pref("browser.safebrowsing.blockedURIs.enabled", false);

/** MOZILLA ***/
user_pref("identity.fxaccounts.enabled", false);
user_pref("browser.tabs.firefox-view", false);
user_pref("dom.push.enabled", false);
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.geo", 2);
user_pref("geo.provider.network.url", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");
user_pref("geo.provider.ms-windows-location", false); // WINDOWS
user_pref("geo.provider.use_corelocation", false); // MAC
user_pref("geo.provider.use_gpsd", false); // LINUX
user_pref("geo.provider.use_geoclue", false); // LINUX
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);

/** TELEMETRY ***/
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);
user_pref("network.connectivity-service.enabled", false);
user_pref("default-browser-agent.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("browser.ping-centre.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

/****************************************************************************
 * SECTION: PESKYFOX                                                        *
****************************************************************************/
/** MOZILLA UI ***/
user_pref("layout.css.prefers-color-scheme.content-override", 2);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("accessibility.force_disabled", 1);
user_pref("devtools.accessibility.enabled", false);
user_pref("browser.compactmode.show", true);
user_pref("browser.privatebrowsing.vpnpromourl", "");
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.tabs.tabmanager.enabled", false);
user_pref("findbar.highlightAll", true);
user_pref("browser.privatebrowsing.enable-new-indicator", false);

/** FULLSCREEN ***/
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.warning.delay", 0);
user_pref("full-screen-api.warning.timeout", 0);

/** URL BAR ***/
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);

/** NEW TAB PAGE ***/
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

/*** POCKET ***/
user_pref("extensions.pocket.enabled", false);

/** DOWNLOADS ***/
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.download.alwaysOpenPanel", false);
user_pref("browser.download.manager.addToRecentDocs", false);
user_pref("browser.download.always_ask_before_handling_new_types", true);

/** PDF ***/
user_pref("browser.download.open_pdf_attachments_inline", true);

/** TAB BEHAVIOR ***/
user_pref("browser.link.open_newwindow.restriction", 0);
user_pref("dom.disable_window_move_resize", true);
user_pref("browser.tabs.loadBookmarksInTabs", true);
user_pref("browser.bookmarks.openInTabClosesMenu", false);
user_pref("clipboard.plainTextOnly", true);
user_pref("dom.popup_allowed_events", "click dblclick");
user_pref("layout.css.has-selector.enabled", true);

/****************************************************************************
 * SECTION: SMOOTHFOX                                                       *
****************************************************************************/
// see https://github.com/yokoffing/Betterfox/blob/master/Smoothfox.js
// Enter your scrolling prefs below this line:
user_pref("general.smoothScroll",                       true); // DEFAULT
user_pref("mousewheel.default.delta_multiplier_y",      275);  // 250-500


////  NATURAL SMOOTH SCROLLING                                                                     preset             info               [default]
user_pref("mousewheel.acceleration.factor", 5);                                            // NSS     5        ACCEL MAX SPEED 1-20           [10]
user_pref("mousewheel.acceleration.start", 4);                                             // NSS     4        accel after x ticks            [-1]
user_pref("mousewheel.default.delta_multiplier_x", 100);                                   // NSS   100           reset previous             [100]
user_pref("mousewheel.default.delta_multiplier_y", 100);                                   // NSS   100           reset previous             [100]
user_pref("mousewheel.default.delta_multiplier_z", 100);                                   // NSS   100           reset previous             [100]
user_pref("mousewheel.system_scroll_override_on_root_content.enabled", false);             // NSS  false       ignoring sys accel           [true]
user_pref("mousewheel.transaction.timeout", 1500);                                         // NSS  1500           reset previous            [1500]
user_pref("mousewheel.min_line_scroll_amount", 0);                                         // NSS     0       lines vary with accel            [5]
user_pref("toolkit.scrollbox.horizontalScrollDistance", 3);                                // NSS     3       keyboard matches mwheel          [5]
user_pref("toolkit.scrollbox.verticalScrollDistance", 3);                                  // NSS     3       keyboard matches mwheel          [3]
user_pref("layers.async-pan-zoom.enabled", true);                                          // NSS  true          smoothness boost           [true]
user_pref("apz.force_disable_desktop_zooming_scrollbars", true);                           // NSS  true          keyboard fix I            [false]
user_pref("apz.paint_skipping.enabled", false);                                            // NSS  false         keyboard fix II v85        [true]
user_pref("dom.event.wheel-deltaMode-lines.always-disabled", true);                        // NSS  true       report wheel in pixels       [false]
user_pref("layout.css.scroll-behavior.spring-constant", "300.0");                          // NSS  "300"      css mimics gecko scroll        [250]
user_pref("general.smoothScroll.mouseWheel.migrationPercent", 100);                        // NSS   100      lame pref wreks settings        [100]
user_pref("general.smoothScroll.msdPhysics.enabled", false);                               // NSS  false        no stutering fling         [false]
user_pref("general.smoothScroll.currentVelocityWeighting", "0.0");                         // NSS  "0.0"          reduce stutter            [0.25]
user_pref("general.smoothScroll.durationToIntervalRatio", 400);                            // NSS   400           reduce stutter             [200]
user_pref("general.smoothScroll.stopDecelerationWeighting", "0.0");                        // NSS  "0.0"          reduce stutter             [0.4]
user_pref("general.smoothScroll.lines.durationMaxMS", 300);                                // NSS   300          arrows smoothing            [150]
user_pref("general.smoothScroll.lines.durationMinMS", 300);                                // NSS   300          arrows smoothing            [150]
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 300);                           // NSS   300          mwheel smoothing            [200]
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 300);                           // NSS   300          mwheel smoothing             [50]
user_pref("general.smoothScroll.other.durationMaxMS", 150);                                // NSS   150          home-end smoothing          [150]
user_pref("general.smoothScroll.other.durationMinMS", 150);                                // NSS   150          home-end smoothing          [150]
user_pref("general.smoothScroll.pages.durationMaxMS", 200);                                // NSS   200         pgup-pgdn smoothing          [150]
user_pref("general.smoothScroll.pages.durationMinMS", 200);                                // NSS   200         pgup-pgdn smoothing          [150]
user_pref("general.smoothScroll.pixels.durationMaxMS", 300);                               // NSS   300           pixel smoothing            [150]
user_pref("general.smoothScroll.pixels.durationMinMS", 300);                               // NSS   300           pixel smoothing            [150]
user_pref("general.smoothScroll.scrollbars.durationMaxMS", 500);                           // NSS   500         scrollbar smoothing          [150]
user_pref("general.smoothScroll.scrollbars.durationMinMS", 500);                           // NSS   500         scrollbar smoothing          [150]

/****************************************************************************
 * START: MY OVERRIDES                                                      *
****************************************************************************/
user_pref("keyword.enabled",true);
user_pref("security.dialog_enable_delay",0);
user_pref("browser.download.always_ask_before_handling_new_types",false);
user_pref("network.trr.mode",3);
user_pref("network.dns.echconfig.enabled",true);
user_pref("network.dns.http3_echconfig.enabled",true);
user_pref("network.dns.use_https_rr_as_altsvc",true);
user_pref("identity.fxaccounts.enabled",true);
user_pref("privacy.sanitize.sanitizeOnShutdown",false);
user_pref("places.history.enabled",true);
user_pref("reader.parse-on-load.enabled", false);
user_pref("browser.urlbar.trimURLs", false);
user_pref("security.enterprise_roots.enabled",true);
user_pref("ui.key.menuAccessKey",17);
user_pref("plugin.state.libgnome-shell-browser-plugin", 0);
user_pref("widget.content.gtk-theme-override", "Adwaita:light");
user_pref("dom.element.popover.enabled",true);
user_pref("webgl.disabled",false);
user_pref("dom.webgpu.enabled",true);
user_pref("browser.migrate.chrome.extensions.enabled",true);
user_pref("extensions.webextensions.restrictedDomains","docs.google.com,github.com");
user_pref("privacy.resistFingerprinting.block_mozAddonManager",true);

/****************************************************************************
 * END: BETTERFOX                                                           *
****************************************************************************/
