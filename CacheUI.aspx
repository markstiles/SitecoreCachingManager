<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="HtmlAgilityPack"%>
<%@ Import Namespace="Sitecore"%>
<%@ Import Namespace="Sitecore.Caching"%>
<%@ Import Namespace="Sitecore.Configuration"%>
<%@ Import Namespace="Sitecore.Data.Managers"%>
<%@ Import Namespace="Sitecore.Diagnostics"%>
<%@ Import Namespace="Sitecore.Web"%>
<%@ Import Namespace="System"%>
<%@ Import Namespace="System.Collections"%>
<%@ Import Namespace="System.Collections.Generic"%>
<%@ Import Namespace="System.Configuration"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Linq"%>
<%@ Import Namespace="System.Text"%>
<%@ Import Namespace="System.Text.RegularExpressions"%>
<%@ Import Namespace="System.Web"%>
<%@ Import Namespace="System.Web.Security"%>
<%@ Import Namespace="System.Web.UI"%>
<%@ Import Namespace="System.Web.UI.HtmlControls"%>
<%@ Import Namespace="System.Web.UI.WebControls"%>
<%@ Import Namespace="System.Web.UI.WebControls.WebParts"%>
<%@ Import Namespace="System.Xml.Linq"%>
<%@ Import Namespace="System.Xml.XPath"%>

<script runat="server">
	/// <summary>
	/// Names
	/// </summary>
	List<string> SiteCacheNames;
	List<string> SystemSiteCacheNames;
	List<string> DBCacheNames;
	List<string> ARCacheNames;
	List<string> MiscDBNames;
	List<string> MiscCacheNames;

	/// <summary>
	/// Types
	/// </summary>
	List<string> SiteCacheTypes;
	List<string> DBCacheTypes;

	//images
	public string SearchBtn = string.Empty;
	public string BtnClear = string.Empty;
	public string ClearAll = string.Empty;
	public string SelectAll = string.Empty;
	public string ProfileBtn = string.Empty;
	public string Summary = string.Empty;

	//Page Load Events
	protected override void OnInit(EventArgs e) {
		Assert.ArgumentNotNull(e, "e");
		base.OnInit(e);
	}

	public string GetIcon(string iconPath, int width, int height) {
		
		HtmlAgilityPack.HtmlDocument htmlDoc = new HtmlAgilityPack.HtmlDocument();
		htmlDoc.LoadHtml(ThemeManager.GetImage(iconPath, width, height));
		HtmlNode img = htmlDoc.DocumentNode.FirstChild;
		return img.Attributes["src"].Value;
	}

	private void Page_Load(object sender, EventArgs e) {

		SearchBtn = string.Format(".btn input.searchBtn {{ background: url('{0}') no-repeat 0 0; }}", GetIcon("Applications/16x16/view.png", 16, 16));
		BtnClear = string.Format(".btn input.BtnClear {{ background: url('{0}') no-repeat 0 0; }}", GetIcon("Applications/16x16/recycle.png", 16, 16));
		ClearAll = string.Format(".btn input.clearAllBtn {{ background: url('{0}') no-repeat 0 0; }}", GetIcon("Applications/16x16/refresh.png", 16, 16));
		SelectAll = string.Format(".btn a.selectAll {{ background: url('{0}') no-repeat -5px -8px; height:17px; padding:2px 4px 0 28px; }}", GetIcon("Control/32x32/checkbox_b_h.png", 32, 32));
		ProfileBtn = string.Format(".btn .profile {{ background: url('{0}') no-repeat 0 0; }} ", GetIcon("Applications/16x16/view_add.png", 16, 16));
		Summary = string.Format(".btn .summary {{ background: url('{0}') no-repeat 0 0; }}", GetIcon("Applications/16x16/view.png", 16, 16));

		imgGlobal.ImageUrl = GetIcon("Network/16x16/earth.png", 16, 16);
		imgSite.ImageUrl = GetIcon("Network/32x32/environment.png", 16, 16);
		imgDB.ImageUrl = GetIcon("Business/32x32/data_view.png", 16, 16);
		imgAR.ImageUrl = GetIcon("Network/32x32/lock.png", 16, 16);
		imgMisc.ImageUrl = GetIcon("People/16x16/cube_blue.png", 16, 16);
		
		if (!IsPostBack) {

			//site types
			SiteCacheTypes = new List<string>() { "[html]", "[xsl]", "[viewstate]", "[registry]", "[filtered items]" };
			foreach (string t in SiteCacheTypes) {
				cblSiteTypes.Items.Add(new ListItem(t, t));
			}

			//site names
			SystemSiteCacheNames = new List<string>() { "admin", "login", "modules_shell", "modules_website", "publisher", "scheduler", "service", "shell", "system", "testing", "website" };
			SiteCacheNames = new List<string>();
			foreach (string si in Factory.GetSiteNames().OrderBy(a => a)) {
				if (!SystemSiteCacheNames.Contains(si)) {
					SiteCacheNames.Add(si);
					cblSiteNames.Items.Add(new ListItem(si, si));
				} else {
					cblSysSiteNames.Items.Add(new ListItem(si, si));
				}
			}

			//db types			
			DBCacheTypes = new List<string>() { "[blobIDs]", "[data]", "[items]", "[paths]", "[standardValues]", "[pivot]" };
			foreach (string t in DBCacheTypes) {
				cblDBTypes.Items.Add(new ListItem(t, t));
			}

			//db names
			DBCacheNames = new List<string>() { "core", "master", "web", "filesystem" };
			foreach (string t in DBCacheNames) {
				cblDBNames.Items.Add(new ListItem(t, t));
			}

			//access result names 
			ARCacheNames = new List<string>() { "AccessResultCache" };
			foreach (string t in ARCacheNames) {
				cblAccessResult.Items.Add(new ListItem(t, t));
			}

			//misc names without random types
			MiscCacheNames = new List<string>() { "clientData", "IsUserInRoleCache", "LanguageProvider - Languages", "Log singles", "ProxyProvider", "SqlDataProvider - Prefetch data(core)", " 	SqlDataProvider - Prefetch data(master)", "SqlDataProvider - Prefetch data(web)", "SqlDataProvider - Property data(core)", "SqlDataProvider - Property data(master)", "SqlDataProvider - Property data(web)", "UserProfileCache", "WebUtil.QueryStringCache" };
			foreach (string t in MiscCacheNames) {
				cblMiscNames.Items.Add(new ListItem(t, t));
			}

			//saw this but it went away, newer versions most likely
			//"rules", 

			UpdateTotals();
		}
	}

	// Events
	protected void c_clearAll_Click(object sender, EventArgs e) {
		foreach (Sitecore.Caching.Cache cache in CacheManager.GetAllCaches()) {
			cache.Clear();
		}
		UpdateTotals();
	}

	protected void rptSCProfiles_DataBound(object sender, RepeaterItemEventArgs e) {
		Repeater rptBySite = (Repeater)e.Item.FindControl("rptBySite");
		Sitecore.Caching.Cache cacheItem = (Sitecore.Caching.Cache)e.Item.DataItem;
		if (rptBySite != null) {
			rptBySite.DataSource = cacheItem.GetCacheKeys();
			rptBySite.DataBind();
		}
	}

	/// <summary>
	/// Sites
	/// </summary>
	/// <param name="sender"></param>
	/// <param name="e"></param>
	protected void FetchSiteCacheProfile(object sender, EventArgs e) {

		rptSiteCacheProfiles.DataSource = GetCachesByNames(GetSelectedSiteNames());
		rptSiteCacheProfiles.DataBind();
	}

	protected void ClearSiteCacheProfile(object sender, EventArgs e) {

		List<Sitecore.Caching.Cache> list = GetCachesByNames(GetSelectedSiteNames());
		ClearCaches(list);
		rptSiteCaches.DataSource = list;
		rptSiteCaches.DataBind();
	}

	protected void FetchSiteCacheList(object sender, EventArgs e) {

		rptSiteCaches.DataSource = GetCachesByNames(GetSelectedSiteNames());
		rptSiteCaches.DataBind();
	}

	/// <summary>
	/// DB
	/// </summary>
	/// <param name="sender"></param>
	/// <param name="e"></param>
	protected void FetchDBCacheProfile(object sender, EventArgs e) {

		rptDBCacheProfiles.DataSource = GetCachesByNames(GetSelectedDBNames());
		rptDBCacheProfiles.DataBind();
	}

	protected void ClearDBCacheProfile(object sender, EventArgs e) {

		List<Sitecore.Caching.Cache> list = GetCachesByNames(GetSelectedDBNames());
		ClearCaches(list);
		rptDBCaches.DataSource = list;
		rptDBCaches.DataBind();
	}

	protected void FetchDBCacheList(object sender, EventArgs e) {

		rptDBCaches.DataSource = GetCachesByNames(GetSelectedDBNames());
		rptDBCaches.DataBind();
	}

	/// <summary>
	/// Access Result
	/// </summary>
	/// <param name="sender"></param>
	/// <param name="e"></param>
	protected void FetchARCacheProfile(object sender, EventArgs e) {

		rptARCacheProfiles.DataSource = GetCachesByNames(GetSelectedItemValues(cblAccessResult.Items));
		rptARCacheProfiles.DataBind();
	}

	protected void ClearARCacheProfile(object sender, EventArgs e) {

		List<Sitecore.Caching.Cache> list = GetCachesByNames(GetSelectedItemValues(cblAccessResult.Items));
		ClearCaches(list);
		rptARCaches.DataSource = list;
		rptARCaches.DataBind();
	}

	protected void FetchARCacheList(object sender, EventArgs e) {

		rptARCaches.DataSource = GetCachesByNames(GetSelectedItemValues(cblAccessResult.Items));
		rptARCaches.DataBind();
	}

	/// <summary>
	/// MISC
	/// </summary>
	/// <param name="sender"></param>
	/// <param name="e"></param>
	protected void FetchMiscCacheProfile(object sender, EventArgs e) {

		rptMiscCacheProfiles.DataSource = GetCachesByNames(GetSelectedItemValues(cblMiscNames.Items));
		rptMiscCacheProfiles.DataBind();
	}

	protected void ClearMiscCacheProfile(object sender, EventArgs e) {

		List<Sitecore.Caching.Cache> list = GetCachesByNames(GetSelectedItemValues(cblMiscNames.Items));
		ClearCaches(list);
		rptMiscCaches.DataSource = list;
		rptMiscCaches.DataBind();
	}

	protected void FetchMiscCacheList(object sender, EventArgs e) {

		rptMiscCaches.DataSource = GetCachesByNames(GetSelectedItemValues(cblMiscNames.Items));
		rptMiscCaches.DataBind();
	}

	/// <summary>
	/// Global Query
	/// </summary>
	/// <param name="sender"></param>
	/// <param name="e"></param>
	protected void btnGQuery_Click(object sender, EventArgs e) {
		List<ListItem> qr = new List<ListItem>();
		IEnumerable<Sitecore.Caching.Cache> allCaches = CacheManager.GetAllCaches().OrderBy(a => a.Name);

		string query = txtGQuery.Text.ToLower();
		foreach (Sitecore.Caching.Cache c in allCaches) {
			try {
				foreach (string s in c.GetCacheKeys()) {
					if (s.ToLower().Contains(query)) {
						qr.Add(new ListItem(c.Name, s));
					}
				}
			} catch (Exception ex) {
				//Sitecore.Caching.AccessResultCacheKey is private and blows up
			}
		}
		rptGQuery.DataSource = qr;
		rptGQuery.DataBind();
		ltlResults.Text = qr.Count.ToString() + " Results";
	}

	protected void btnGQueryClear_Click(object sender, EventArgs e) {
		List<ListItem> qr = new List<ListItem>();
		var allCaches = CacheManager.GetAllCaches().OrderBy(a => a.Name);

		string query = txtGQuery.Text.ToLower();
		foreach (Sitecore.Caching.Cache c in allCaches) {
			try {
				foreach (string s in c.GetCacheKeys()) {
					if (s.ToLower().Contains(query)) {
						c.Remove(s);
					}
				}
			} catch (Exception ex) {
				//Sitecore.Caching.AccessResultCacheKey is private and blows up
			}
		}
		rptGQuery.DataSource = qr;
		rptGQuery.DataBind();
		ltlResults.Text = qr.Count.ToString() + " Results";
	}

	//Helpers
	protected void ClearCaches(List<Sitecore.Caching.Cache> caches) {
		foreach (Sitecore.Caching.Cache c in caches) {
			c.Clear();
		}
	}

	protected List<string> GetSelectedSiteNames() {

		List<string> returnNames = new List<string>();

		//get selected types
		List<string> siteTypesSelected = new List<string>();
		foreach (ListItem li in cblSiteTypes.Items) {
			if (li.Selected) {
				siteTypesSelected.Add(li.Value);
			}
		}

		//get selected sites caches
		List<Sitecore.Caching.Cache> allCaches = new List<Sitecore.Caching.Cache>();
		List<string> list = GetSelectedItemValues(cblSiteNames.Items);
		list.AddRange(GetSelectedItemValues(cblSysSiteNames.Items));
		foreach (string li in list) {
			foreach (string s in siteTypesSelected) {
				returnNames.Add(li + s);
			}
		}

		return returnNames;
	}

	protected List<string> GetSelectedDBNames() {

		List<string> returnNames = new List<string>();

		//get selected types
		List<string> siteTypesSelected = new List<string>();
		foreach (ListItem li in cblDBTypes.Items) {
			if (li.Selected) {
				siteTypesSelected.Add(li.Value);
			}
		}

		//get selected sites caches
		List<Sitecore.Caching.Cache> allCaches = new List<Sitecore.Caching.Cache>();
		List<string> list = GetSelectedItemValues(cblDBNames.Items);
		foreach (string li in list) {
			foreach (string s in siteTypesSelected) {
				returnNames.Add(li + s);
			}
		}

		return returnNames;
	}

	protected List<Sitecore.Caching.Cache> GetCachesByNames(List<string> names) {

		List<Sitecore.Caching.Cache> returnCaches = new List<Sitecore.Caching.Cache>();
		foreach (string s in names) {
			Sitecore.Caching.Cache c = CacheManager.FindCacheByName(s);
			if (c != null) {
				returnCaches.Add(c);
			}
		}
		return returnCaches;
	}

	protected List<string> GetSelectedItemValues(ListItemCollection lic) {
		List<string> lil = new List<string>();
		foreach (ListItem li in lic) {
			if (li.Selected) {
				lil.Add(li.Value);
			}
		}
		return lil;
	}

	protected string GetValFromB(long l) {
		long mb = 1048576;
		long kb = 1024;
		if (l > mb) {
			return (l / mb).ToString() + "MB";
		} else if (l > kb) {
			return (l / kb).ToString() + "KB";
		}
		return l.ToString() + "B";
	}

	private void UpdateTotals() {
		CacheStatistics statistics = CacheManager.GetStatistics();
		ltlEntries.Text = statistics.TotalCount.ToString();
		ltlSize.Text = GetValFromB(statistics.TotalSize);
	}

	protected string GetClass(int ItemIndex) {
		return ((ItemIndex % 2).Equals(0)) ? "even" : "odd";
	}
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    <style>
		.clear { clear:both; }
		* { color:#333; }
		body { background:url("/sitecore/shell/themes/standard/gradients/gray1.gif") repeat-y scroll 50% 0 #4E4E4E; margin:0px; padding:0px; }
		h1, h2, h3, h4 { padding: 5px; margin:5px; color:#fff; font-style:normal; font-family:Tahoma;}
		h1 { font-size:22px; font-family:Tahoma; font-weight:normal; }
		h2 { background: none repeat scroll 0 0 #D9D9D9; border-bottom: 1px solid #ccc; display:block; margin:0px;
                border-top: 1px solid #fff; color: #555555; font: bold 8pt tahoma; padding: 1px 2px; }
			h2 a { font-weight:normal; display:inline-block; margin-left:20px; }
		h3 { font-size:14px; background-color:#ccc; font-weight:normal; }
			h3 span { font-weight:normal; }
		h4 { margin: 5px 0; color:#444; }
			h4 span { font-size:12px; font-weight:normal; }
		.title { font-weight:bold; color:#444; }
		.spacer { background:#fff; height: 15px; border-right:1px solid #333; border-left:1px solid #333; }
		.ActiveRegion,
		.Region { background:#F0F1F2; border-right:1px solid #333; border-left:1px solid #333; border-bottom:1px solid #333; position:relative; }
		.Region { display:none; }
		.Section { }
		.ButtonSection { background-color:#cccccc; }
		.BtnClear { float:right; }
		.GlobalSearch, .SiteCacheList, .SiteProfileList, .DBCacheList, .DBProfileList, .ARCacheList, .ARProfileList, .MiscCacheList, .MiscProfileList { position:relative; }
		.Controls { padding:10px; font:8pt tahoma; }
			.fieldHighlight { border-left:4px solid #CCCCCC; padding-left:8px;}
			.dataRow { margin-bottom:5px; }
			.txtQuery { width:500px; margin-top:5px; }
			.btnSpacer { float:left; line-height:16px; }
			.rowSpacer { height:15px; }
			.Controls span { display:inline-block; margin-right:20px;}
			.GlobalSearch .ButtonSection span { display:inline-block; margin-left:30px; }
		.CacheSiteForm, .CacheList, .ProfileList, .GlobalSearch { }
			.CacheSiteForm .Section { display:none;}
			.CacheSiteForm a { margin:10px 0; font-size:12px; color:#000; }
			.CacheSiteForm .Section { padding:0px 5px; background:none; } 
		.CacheList {  }
			.ProfileList .Section, .CacheList .Section, .ButtonSection, .GlobalSearch .Section { padding:0px 5px 5px; background:none; display:block; }
			.ResultTitle { margin-bottom: 5px; padding: 0 5px; }
			.Results { background:#fff; border:2px groove #f0f0f0; margin-bottom: 5px; max-height: 350px; overflow: auto; padding: 0 5px;}
			.FormTitleRow { clear:both; padding:0 5px 5px; }
			.FormRow { clear:both; border-bottom:1px dashed #ccc; margin-bottom:3px; padding-bottom:3px; }
			.RowTitle { float:left; font-weight:bold; }
				.Results .RowTitle { font-style:italic; }
			.RowValue { float:left; }
			.CacheName { width:175px; }
			.CacheKey {  }
			.Name { width: 250px }
			.Count { width: 150px }
			.Size { width: 150px }
			.MaxSize { width: 150px }
		.CacheItems { margin:0 10px 0 20px; }
		.overlay { padding-top:40px; display:none; position:absolute; top:0px; bottom:0px; right:0px; left:0px; text-align:center; background-color:#ffffff; filter:alpha(opacity=60); opacity:0.6; }
			.overlay .message { position:absolute; top:40px; width:100%; color:#333; font-family:Tahoma; font-size:19px; font-weight:bold; }
	    /*Sitecorey styles */
	    #EditorTabs { height: 24px; vertical-align: top;
            background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab7.png") repeat-x scroll 0 0 #888888;
        }
            .activeTab { color: black; float: left; height: 24px; outline: medium none; padding: 0; text-decoration: none; white-space: nowrap; }
            .normalTab { }
                .tabOpen { /* */ }
				.firstTab .tabOpen { float: left; width:6px; height:24px;
				    background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab0.png") no-repeat 0 0; }
                .activeTab .tabOpen { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab0_h.png") no-repeat 0 0; }
                .tabInfo { float:left; height:24px; padding:4px 0 0; 
                    background: url("/sitecore/shell/Themes/Standard/Images/Ribbon/tab1.png") repeat-x 0 0;    
                }
                .activeTab .tabInfo { background: url("/sitecore/shell/Themes/Standard/Images/Ribbon/tab1_h.png") repeat-x 0 0; }
                    .tabIcon { width:16px; height:16px; margin: 0 2px 0 0; vertical-align: middle; }
                    .tabInfo span { color:#333; font:8pt tahoma; }
                    .tabInfo img { padding-right:5px; float:left; display:inline-block; }
                .tabClose { float:left; height:24px; width: 21px; 
                    background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab2.png") no-repeat 0 0;
                }
                .activeTab .tabClose { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab2_h1.png") no-repeat 0 0 }
				.prevTab .tabClose { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab2_h2.png") no-repeat 0 0 }
				.lastTab .tabClose { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab3.png") no-repeat 0 0 }
				.activeTab.lastTab .tabClose { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab3_h.png") no-repeat 0 0 }
				
            .btnBox { display:inline-block; height:20px; margin:5px 0; }
		        .btnMessage { float:left; padding:9px 0px 15px 5px; margin:1px; }
		        .btn { float:left; padding: 3px 4px 3px 9px; margin:1px; }
		        .btn:hover { background: url("/sitecore/shell/themes/standard/images/Ribbon/SmallButtonActive.png") repeat-x scroll 0 0 #fffbd3; 
                    border-style:solid; border-width:1px; border-color:#ddcf9b #d2c08e #ccc2a3; margin:0px;             
                }
		            .btn img { float:left; }
		            .btn input,
		            .btn a { color:#303030; font-family: tahoma; font-size: 8pt; border:none; background:none; 
		                            float:left; height:15px; padding:0 0 3px 20px; 
                    }
                        
						.btn a.toggle { padding-right:4px; text-decoration:none; background: url('/sitecore/shell/themes/standard/Images/expand15x15.gif') no-repeat 0 0; }
                        <%= SearchBtn %>
		                <%= BtnClear %>
		                <%= ClearAll %>
		                <%= SelectAll %>
		                <%= ProfileBtn %>
		                <%= Summary %>
	</style>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript">
    	$(document).ready(function () {
    		var allTabs = ".normalTab, .activeTab";
    		$(allTabs).click(function (e) {
    			e.preventDefault();
    			if ($(this).attr("class").indexOf("normalTab") > -1) {
    				//sort out active and normal tabs
    				$(".activeTab").removeClass("activeTab").addClass("normalTab");
    				$(this).removeClass("normalTab").addClass("activeTab");
    				//sort out prev tab
    				$(".prevTab").removeClass("prevTab");
    				var prev = $(this).prev();
    				if (prev != null)
    					$(prev).addClass("prevTab");
    				var newRegion = $(this).attr("rel");
    				$(".ActiveRegion").removeClass("ActiveRegion").addClass("Region");
    				$("." + newRegion).removeClass("Region").addClass("ActiveRegion");
    			}
    		});
    		$('h2').dblclick(function () {
    			$(this).next(".Controls").toggle();
    		});
    	});
    	var IsSiteChecked = false;
    	function CheckAll(link, cssClass) {
    		var split = "";
    		var join = ""
    		if ($(link).text().indexOf("deselect") >= 0) {
    			split = "deselect";
    			join = "select";
    			IsSiteChecked = false;
    		} else {
    			split = "select";
    			join = "deselect";
    			IsSiteChecked = true;
    		}

    		var newText = $(link).text().split(split).join(join);
    		$(link).text(newText);

    		$("." + cssClass + " input:checkbox").each(function () {
    			$(this).attr('checked', IsSiteChecked);
    		});
    	}
    	var OverlayObject;
    	function beginRequest(sender, args) {
    		var clientId = args.get_postBackElement().id;
    		var wrapper = $("#" + clientId).attr("rel");
    		OverlayObject = $(wrapper).find(".overlay");
    		$(OverlayObject).css("display", "block");
    	}
    	function endRequest(sender, args) {
    		$(OverlayObject).css("display", "none");
    	}
    </script>
</head>
<body>
    <form id="form1" defaultbutton="btnGQuery" runat="server">
		<asp:ScriptManager ID="scriptManager" runat="server"></asp:ScriptManager>
		<script type="text/javascript" language="javascript">
			Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequest);
			Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);
        </script>
		<h1>Caching Manager</h1>
		<div id="EditorTabs">
            <a class="activeTab firstTab" href="#" rel="GlobalRegion">
                <div class="tabOpen"></div>
                <div class="tabInfo">
                    <asp:Image runat="server" ID="imgGlobal" />
                    <span>Global Search</span>
                </div>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab" href="#" rel="SiteRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <asp:Image runat="server" ID="imgSite" />
                    <span>Caches By Site</span>
                </span>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab" href="#" rel="DatabaseRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <asp:Image runat="server" ID="imgDB" />
                    <span>Caches By Database</span>
                </span>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab" href="#" rel="ARRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <asp:Image runat="server" ID="imgAR" />
                    <span>Access Result Caches</span>
                </span>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab lastTab" href="#" rel="MiscRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <asp:Image runat="server" ID="imgMisc" />
                    <span>Access Result Caches</span>
                </span>
                <div class="tabClose"></div>
            </a>
        </div>
        <div class="spacer">&nbsp;</div>
        <div class="ActiveRegion GlobalRegion">
			<asp:UpdatePanel ID="upGQuery" runat="server" UpdateMode="Conditional">
				<ContentTemplate>
                    <h2>Cache Information</h2>
			        <div class="Controls">
						<div class="dataRow">
                            Total Cache Size: <span class="title"><asp:Literal ID="ltlSize" runat="server"></asp:Literal></span>
						</div>
                        <div class="dataRow">
                            Cache Entries: <span class="title"><asp:Literal ID="ltlEntries" runat="server"></asp:Literal></span>
						</div>
                        <div class="clear"></div>
			        </div>
                    <h2>Cache Search</h2>
                    <div class="Controls">
                        <div class="fieldHighlight">
                            <asp:TextBox ID="txtGQuery" CssClass="txtQuery" runat="server"></asp:TextBox>				
						    <div class="clear"></div>    
                        </div>
                        <div class="rowSpacer"></div>
                        <div class="fieldHighlight">
							<div class="btnBox">
                                <div class="btn">
                                    <asp:Button ID="btnGQuery" CssClass="searchBtn" rel=".GlobalRegion" Text="Search All Cache" runat="server" OnClick="btnGQuery_Click" />        
                                </div>
                                <div class="btnSpacer">.</div>
                                <div class="btn">
                                    <asp:Button ID="btnGQueryClear" rel=".GlobalRegion" CssClass="BtnClear" Text="Clear Search Results" runat="server" OnClick="btnGQueryClear_Click" />
                                </div>
                                <div class="btnSpacer">.</div>
                                <div class="btn">
                                    <asp:button ID="c_clearAll" rel=".GlobalRegion" CssClass="clearAllBtn" runat="server" Text="Clear All Cache" OnClick="c_clearAll_Click"></asp:button>
						        </div>
                            </div>
                            <div class="clear"></div>
							<div class="btnMessage">
								<asp:Literal ID="ltlResults" runat="server"></asp:Literal>
							</div>
					        <asp:Repeater ID="rptGQuery" runat="server">
						        <HeaderTemplate>
									<div class="FormTitleRow">
										<div class="CacheName RowTitle">Cache Name</div>
										<div class="CacheKey RowTitle">Cache Key</div>
										<div class="clear"></div>
									</div>
							        <div class="Results GlobalResults">
						        </HeaderTemplate>
						        <ItemTemplate>
							        <div class="FormRow">
								        <div class="CacheName RowValue">
									        <%# ((System.Web.UI.WebControls.ListItem)Container.DataItem).Text %>
								        </div>
								        <div class="CacheKey RowValue">
									        <%# ((System.Web.UI.WebControls.ListItem)Container.DataItem).Value %>
								        </div>
								        <div class="clear"></div>
							        </div>
						        </ItemTemplate>
						        <FooterTemplate></div></FooterTemplate>
					        </asp:Repeater>
                        </div>
                    </div>
				</ContentTemplate>
			</asp:UpdatePanel>
			<div class="overlay"><div class="message">Loading...</div></div>
			<div class="clear"></div>
		</div>
		<div class="Region SiteRegion">			
            <h2>Search Criteria</h2>
			<div class="Controls">
				<div class="fieldHighlight">
					<div class="FormTitleRow">
						<div class="RowTitle">Type</div>
					</div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'SiteTypeChecks');return false;">select all - (choose at least one)</a>
						</div>
					</div>
					<div class="SiteTypeChecks">
						<asp:CheckBoxList ID="cblSiteTypes" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
				<div class="rowSpacer"></div>
				<div class="fieldHighlight">
					<div class="FormTitleRow">
						<div class="RowTitle">System Names </div>
					</div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'SysChecks');return false;">select all - (choose at least one of either system or site name)</a>
						</div>
					</div>
					<div class="SysChecks">
						<asp:CheckBoxList ID="cblSysSiteNames" RepeatColumns="12" runat="server"></asp:CheckBoxList>
					</div>
				</div>
				<div class="rowSpacer"></div>
				<div class="fieldHighlight">
					<div class="FormTitleRow">
						<div class="RowTitle">Site Names</div>
					</div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'SiteChecks');return false;">select all</a>
						</div>					
					</div>
					<div class="SiteChecks">
						<asp:CheckBoxList ID="cblSiteNames" RepeatColumns="10" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<h2>Search Results</h2>
			<div class="Controls">
				<asp:UpdatePanel ID="UpdatePanel2" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="fieldHighlight">
							<div class="btnBox">
								<div class="btn">
									<asp:button ID="btnFetch" rel=".SiteRegion" CssClass="summary" runat="server" Text="Get Summary" OnClick="FetchSiteCacheList"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button6" rel=".SiteRegion" CssClass="profile" runat="server" Text="Get Cache Entries" OnClick="FetchSiteCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button8" rel=".SiteRegion" CssClass="BtnClear" runat="server" Text="Clear Cache Entries" OnClick="ClearSiteCacheProfile"></asp:button>
								</div>
							</div>
							<div class="CacheList SiteCacheList">
								<asp:Repeater ID="rptSiteCaches" runat="server">
									<HeaderTemplate>
										<div class="FormTitleRow">
											<div class="Name RowTitle">Name</div>
											<div class="Count RowTitle">Cache Entries</div>
											<div class="Size RowTitle">Size</div>
											<div class="MaxSize RowTitle">MaxSize</div>
											<div class="clear"></div>
										</div>
										<div class="Results">
									</HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
											<div class="Name RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %></div>
											<div class="Count RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></div>
											<div class="Size RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></div>
											<div class="MaxSize RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></div>
											<div class="clear"></div>
										</div>	
									</ItemTemplate>
									<FooterTemplate>
										</div>
									</FooterTemplate>
								</asp:Repeater>
							</div>
							<div class="ProfileList SiteProfileList">
								<asp:Repeater ID="rptSiteCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
									<HeaderTemplate>
										<div class="Results">
									</HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow">
											<h4><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %> - 
												<span>Cache Entries:</span> <span class="title"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></span>
												<span>Size:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></span>
												<span>MaxSize:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></span>
											</h4>
											<div class="CacheItems">
												<asp:Repeater ID="rptBySite" runat="server">
													<HeaderTemplate>
														<div class="FormRow">
															<div class="CacheID RowTitle">Cache ID</div>
															<div class="clear"></div>
														</div>
													</HeaderTemplate>
													<ItemTemplate>
														<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
															<div class="CacheID"><%# Container.DataItem %></div>
														</div>
													</ItemTemplate>
												</asp:Repeater>
											</div>
										</div>
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>	
							</div>
						</div>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay"><div class="message">Loading...</div></div>	
			</div>
		</div>
		<div class="Region DatabaseRegion">
			<h2>Search Criteria</h2>
			<div class="Controls">
				<div class="fieldHighlight">
					<div class="FormTitleRow"><div class="RowTitle">Types</div></div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'DBTypeChecks');return false;">select all (choose at least one)</a>
						</div>
					</div>
					<div class="DBTypeChecks">
						<asp:CheckBoxList ID="cblDBTypes" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
				<div class="rowSpacer"></div>
				<div class="fieldHighlight">
					<div class="FormTitleRow"><div class="RowTitle">Database Names</div></div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'DBChecks');return false;">select all (choose at least one of either system or site name)</a>
						</div>
					</div>
					<div class="DBChecks">
						<asp:CheckBoxList ID="cblDBNames" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<h2>Search Results</h2>
			<div class="Controls">
				<asp:UpdatePanel ID="UpdatePanel4" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="fieldHighlight">
							<div class="btnBox">
								<div class="btn">
									<asp:button ID="Button1" rel=".DatabaseRegion" class="summary" runat="server" Text="Get Summary" OnClick="FetchDBCacheList"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button5" rel=".DatabaseRegion" class="profile" runat="server" Text="Get Cache Entries" OnClick="FetchDBCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button10" rel=".DatabaseRegion" runat="server" CssClass="BtnClear" Text="Clear Cache Entries" OnClick="ClearDBCacheProfile"></asp:button>
								</div>
							</div>
							<div class="CacheList DBCacheList">
								<asp:Repeater ID="rptDBCaches" runat="server">
									<HeaderTemplate>
										<div class="FormTitleRow">
											<div class="Name RowTitle">Name</div>
											<div class="Count RowTitle">Cache Entries</div>
											<div class="Size RowTitle">Size</div>
											<div class="MaxSize RowTitle">MaxSize</div>
											<div class="clear"></div>
										</div>
										<div class="Results">
									</HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
											<div class="Name RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %></div>
											<div class="Count RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></div>
											<div class="Size RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></div>
											<div class="MaxSize RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></div>
											<div class="clear"></div>
										</div>
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>
							</div>
							<div class="ProfileList DBProfileList">
								<asp:Repeater ID="rptDBCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
									<HeaderTemplate><div class="Results"></HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow">
											<h4><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %> - 
												<span>Cache Entries:</span> <span class="title"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></span>
												<span>Size:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></span>
												<span>MaxSize:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></span>
											</h4>
											<div class="CacheItems">
												<asp:Repeater ID="rptBySite" runat="server">
													<HeaderTemplate>
														<div class="FormRow">
															<div class="CacheID RowTitle">Caching ID</div>
															<div class="clear"></div>
														</div>
													</HeaderTemplate>
													<ItemTemplate>
														<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
															<div class="CacheID"><%# Container.DataItem %></div>
														</div>
													</ItemTemplate>
												</asp:Repeater>
											</div>
										</div>
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>
							</div>
						</div>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay"><div class="message">Loading...</div></div>
			</div>
		</div>
		<div class="Region ARRegion">
			<h2>Search Criteria</h2>
			<div class="Controls">
				<div class="fieldHighlight">
					<div class="FormTitleRow"><div class="RowTitle">Cache Names</div></div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn"> 
							<a href="#" class="selectAll" onclick="CheckAll(this, 'MiscChecks');return false;">select all (choose at least one)</a>						
						</div>
					</div>
					<div class="MiscChecks">
						<asp:CheckBoxList ID="cblAccessResult" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<h2>Search Results</h2>
			<div class="Controls">
				<asp:UpdatePanel ID="UpdatePanel64" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="fieldHighlight">
							<div class="btnBox">
								<div class="btn">
									<asp:button ID="Button2" rel=".ARRegion" class="summary" runat="server" Text="Get Summary" OnClick="FetchARCacheList"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button7" rel=".ARRegion" class="profile" runat="server" Text="Get Cache Entries" OnClick="FetchARCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button11" rel=".ARRegion" runat="server" CssClass="BtnClear" Text="Clear Cache Entries" OnClick="ClearARCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer"></div>
							</div>
						</div>
						<div class="CacheList ARCacheList">	
							<asp:Repeater ID="rptARCaches" runat="server">
							<HeaderTemplate>
								<div class="FormTitleRow">
									<div class="Name RowTitle">Name</div>
									<div class="Count RowTitle">Cache Entries</div>
									<div class="Size RowTitle">Size</div>
									<div class="MaxSize RowTitle">MaxSize</div>
									<div class="clear"></div>
								</div>
								<div class="Results">
							</HeaderTemplate>
							<ItemTemplate>
								<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
									<div class="Name RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %></div>
									<div class="Count RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></div>
									<div class="Size RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></div>
									<div class="MaxSize RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></div>
									<div class="clear"></div>
								</div>	
							</ItemTemplate>
							<FooterTemplate></div></FooterTemplate>
						</asp:Repeater>
						</div>
						<div class="ProfileList ARProfileList">
							<asp:Repeater ID="rptARCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
								<HeaderTemplate><div class="Results"></HeaderTemplate>
								<ItemTemplate>
									<div class="FormRow">
										<h4><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %> - 
											<span>Cache Entries:</span> <span class="title"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></span>
											<span>Size:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></span>
											<span>MaxSize:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></span>
										</h4>
										<div class="CacheItems">
											<asp:Repeater ID="rptBySite" runat="server">
												<HeaderTemplate>
													<div class="FormRow">
														<div class="CacheID RowTitle">Caching ID</div>
														<div class="clear"></div>
													</div>
												</HeaderTemplate>
												<ItemTemplate>
													<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
														<div class="CacheID"><%# Container.DataItem %></div>
													</div>
												</ItemTemplate>
											</asp:Repeater>
										</div>
									</div>
								</ItemTemplate>
								<FooterTemplate></div></FooterTemplate>
							</asp:Repeater>
						</div>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay"><div class="message">Loading...</div></div>
			</div>
		</div>
		<div class="Region MiscRegion">
			<h2>Search Criteria</h2>
			<div class="Controls">
				<div class="fieldHighlight">
					<div class="FormTitleRow"><div class="RowTitle">Cache Names</div></div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'MiscChecks');return false;">select all (choose at least one)</a> 
						</div>
					</div>
					<div class="MiscChecks">
						<asp:CheckBoxList ID="cblMiscNames" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<h2>Search Results</h2>
			<div class="Controls">
				<asp:UpdatePanel ID="UpdatePanel6" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="fieldHighlight">
							<div class="btnBox">
								<div class="btn">
									<asp:button ID="Button3" rel=".MiscRegion" class="summary" runat="server" Text="Get Summary" OnClick="FetchMiscCacheList"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button4" rel=".MiscRegion" class="profile" runat="server" Text="Get Cache Entries" OnClick="FetchMiscCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button13" rel=".MiscRegion" runat="server" CssClass="BtnClear" Text="Clear Cache Entries" OnClick="ClearMiscCacheProfile"></asp:button>
								</div>
							</div>
							<div class="CacheList MiscCacheList">
								<asp:Repeater ID="rptMiscCaches" runat="server">
									<HeaderTemplate>
										<div class="FormTitleRow">
											<div class="Name RowTitle">Name</div>
											<div class="Count RowTitle">Cache Entries</div>
											<div class="Size RowTitle">Size</div>
											<div class="MaxSize RowTitle">MaxSize</div>
											<div class="clear"></div>
										</div>
										<div class="Results">
									</HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
											<div class="Name RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %></div>
											<div class="Count RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></div>
											<div class="Size RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></div>
											<div class="MaxSize RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></div>
											<div class="clear"></div>
										</div>	
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>
							</div>
							<div class="ProfileList MiscProfileList">
								<asp:Repeater ID="rptMiscCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
									<HeaderTemplate><div class="Results"></HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow">
											<h4><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %> - 
												<span>Cache Entries:</span> <span class="title"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></span>
												<span>Size:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></span>
												<span>MaxSize:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></span>
											</h4>
											<div class="CacheItems">
												<asp:Repeater ID="rptBySite" runat="server">
													<HeaderTemplate>
														<div class="FormRow">
															<div class="CacheID RowTitle">Caching ID</div>
															<div class="clear"></div>
														</div>
													</HeaderTemplate>
													<ItemTemplate>
														<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
															<div class="CacheID"><%# Container.DataItem %></div>
														</div>
													</ItemTemplate>
												</asp:Repeater>
											</div>
										</div>
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>
							</div>
						</div>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay"><div class="message">Loading...</div></div>
			</div>
		</div>
    </form>
</body>
</html>