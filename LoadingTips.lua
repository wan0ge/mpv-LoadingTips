-- 在视频还在加载时显示 OSD 提示
-- 十分简易的mpv lua插件脚本，用于mpv加载文件时显示一个加载中提示
-- https://github.com/wan0ge/mpv-LoadingTips

local last_show_time = 0
local check_playback_timer = nil

local function stop_loading_message()
    mp.set_osd_ass(0, 0, "")
end

local function show_loading_message()
    local current_time = os.time()
    
    -- 执行前检查是否在 60 秒 CD 中
    if current_time - last_show_time < 60 then return end
    
    last_show_time = current_time

    mp.add_timeout(0.1, function()
        local osd_w = mp.get_property_number("osd-width", 1920) -- 获取 OSD 画布宽度
        local osd_h = mp.get_property_number("osd-height", 1080) -- 获取 OSD 画布高度

        -- 计算右上角位置（偏移 30 像素）
        local x = osd_w - 30   -- 右侧对齐
        local y = 30           -- 上侧对齐
        local font_size = math.floor(50 * (osd_h / 1080)) -- 自适应字体大小

        -- 生成 OSD 提示（右上角对齐）
        local ass = string.format("{\\an9\\bord2\\alpha&H19&}{\\pos(%d,%d)}{\\fs%d}播放emby需要等待10s+", x, y, font_size)
        --local ass = string.format("{\\an9\\bord2\\alpha&H19&}{\\pos(%d,%d)}{\\fs%d}少女祈祷中……", x, y, font_size)
        mp.set_osd_ass(osd_w, osd_h, ass)

        -- 清除之前的定时器
        if check_playback_timer then 
            pcall(function() mp.remove_periodic_timer(check_playback_timer) end)
            check_playback_timer = nil
        end

        local initial_check_count = 0
        check_playback_timer = mp.add_periodic_timer(0.1, function()
            local is_video = mp.get_property_bool("vid")
            local paused = mp.get_property_bool("pause")
            local demux_cache_time = mp.get_property_number("demuxer-cache-time", 0)
            local time_pos = mp.get_property_number("time-pos", 0)
            
            -- 前 0.01 秒内强制检查是否满足条件
            initial_check_count = initial_check_count + 1
            if initial_check_count > 0.01 then  -- 0.01秒内
                -- 首次检查到视频稳定就关闭提示
                if time_pos > 0.1 and demux_cache_time > 0.5 and not paused then
                    stop_loading_message()
                    -- 使用 pcall 安全移除定时器
                    pcall(function() 
                        if check_playback_timer then
                            mp.remove_periodic_timer(check_playback_timer)
                        end
                    end)
                    check_playback_timer = nil
                    return
                end
            end

            -- 如果没有视频流，保持提示
            if not is_video then
                return
            end
        end)
    end)
end

-- 在窗口显示和切换文件时都显示提示
mp.register_event("video-reconfig", show_loading_message)
mp.register_event("file-loaded", show_loading_message)
