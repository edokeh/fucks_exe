$(function() {
    $("#downloadBtn").show();

    if (typeof(downloading_file) != 'undefined') {
        renderDownload(downloading_file);
        renderProgress(downloading_file.id);
        $("#downloadBtn").attr("disabled", true);
    }

    $(window).keyup(function(e){
        //shift + p
        if(e.shiftKey && e.which === 80){
            $("#pcode").show();
        }
    });

    $("#downloadForm").submit(function() {
        if ($.trim($("#url").val()) === "") {
            return false;
        }
        $("#downloadBtn").attr("disabled", true).val("连接中...");
        $.get("/http_files/size", {
            url: $("#url").val(),
            pcode: $("#pcode").val()
        }, function(data) {
            if (data.error) {
                $("#error").html("错误：" + data.error).fadeIn();
                $("#downloadBtn").attr("disabled", false);
                setTimeout(function() {
                    $("#error").fadeOut();
                }, 2000);
            } else {
                renderDownload(data);
                startDownload(data);
            }
            $("#downloadBtn").val("给老子下！");
        });
        return false;
    });

    /**
     * 渲染开始下载的页面
     */
    function renderDownload(data) {
        $("#downloadWrapper .tip").html("服务器疯狂下载中，稍等...");
        $("#downloadWrapper .fileName").html(data.filename + " (" + data.size + ")").removeClass("link");
        $(".ProgressBar .BarValue").css("width", 0);
        $(".ProgressBar .BarText").text("0%");
        $("#downloadWrapper").show();

    }

    /**
     * 向服务器请求，开始下载
     */
    function startDownload() {
        $.post("/http_files", {
            url: $("#url").val(),
            pcode: $("#pcode").val()
        }, function(id) {
            renderProgress(id);
        });
        $("#pcode").val("").hide();
        return false;
    }

    /**
     * 渲染进度，包括下载完成时的处理
     */
    function renderProgress(id) {
        var func = arguments.callee;
        $.get("/http_files/" + id + "/percent", function(percent) {
            $(".ProgressBar .BarValue").css("width", percent + "%");
            $(".ProgressBar .BarText").text(percent + "%");
            if (percent >= 100) {
                $(".ProgressBar").hide();
                $("#downloadWrapper .tip").html("服务器下载完成！");
                $("#downloadWrapper .fileName").attr("href", "/http_files/" + id).addClass("link");
                $("#downloadBtn").attr("disabled", false);
            } else {
                setTimeout(func, 1000, id);
            }
        });
    }
});