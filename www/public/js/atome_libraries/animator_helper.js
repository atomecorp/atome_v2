class AnimationHelper {
    constructor() {
        $.getScript("js/third_parties/rendering_engines/popmotion.global.min.js", function () {
        });
    }
}

animator = {
    is_mobile: function () {
        atome.jsIsMobile();
    },
    animation: function (value) {
        let target = Opal.Object.$grab(value.target);
        let target_id = target.atome_id;
        let objectType = target.type;
        let start = value.start;
        let end = value.end;
        let duration = value.duration;
        let curve = value.curve;
        let property = value.property;
        let finished = value.finished;
        let loop = value.loop;
        let yoyo = value.yoyo;
        let a_start = {};
        let a_end = {};
        let a_duration = {};
        let a_curve = {};
        let a_property = {};
        let a_finished = {};
        if (start === "") {
            start = 0;
        }
        if (end === "") {
            end = 200;
        }

        if (duration === "") {
            duration = 2000;
        }
        if (property === "") {
            property = "x";
        }

        if (curve === "") {
            curve = "Out";
        }

        if (finished === "") {
            finished = "";
        }
        if (loop === "") {
            loop = 0;
        }


        if (typeof (start) == "object") {
            const start_opt = Object.keys(value.start);
            start_opt.forEach((item) => {
                let key = item;
                let val = value.start[item];
                if (key == "background" && objectType == "text") {
                    key = "background-image";
                    if (typeof (val) == "string") {
                        val = "linear-gradient(0deg, " + val + "," + val + ")";
                    } else {
                        //  gradient handling here
                        let gradient = [];
                        $.each(val, function (key_nb, values) {
                            let color = "";
                            let i = 0;
                            $.each(values, function (key, value) {
                                if (i == 0) {
                                    separator = "";
                                } else {
                                    separator = ",";
                                }
                                // red green blue are formatted to be coded on 8 bit not the alpha

                                if (i<3){
                                    value = parseFloat(value) * 255;
                                }
                                color = color + separator + value;
                                i += 1;
                            });
                            color = "rgba(" + color + ")";
                            gradient.push(color);

                        });
                        val = "linear-gradient(0deg, " + gradient.join(",") + ")";
                    }
                }
                a_start[key] = val;
            });
        } else {
            a_start[property] = start;
        }
        if (typeof (end) == "object") {
            const end_option = Object.keys(value.end);
            end_option.forEach((item) => {
                let key = item;
                let val = value.end[item];


                if (key == "background" && objectType == "text") {

                    key = "background-image";
                    if (typeof (val) == "string") {
                        val = "linear-gradient(0deg, " + val + "," + val + ")";
                    } else {
                        //  gradient handling here
                        let gradient = [];
                        $.each(val, function (key_nb, values) {
                            let color = "";
                            let i = 0;
                            $.each(values, function (key, value) {
                                if (i == 0) {
                                    separator = "";
                                } else {
                                    separator = ",";
                                }
                                // red green blue are formatted to be coded on 8 bit not the alpha
                                if (i<3){
                                    value = parseFloat(value) * 255;
                                }
                                color = color + separator + value;
                                i += 1;
                            });
                            color = "rgba(" + color + ")";
                            gradient.push(color);
                        });
                        val = "linear-gradient(0deg, " + gradient.join(",") + ")";
                    }
                }
                if (key == "background") {
                   if ($("#"+target_id).children.length > 0){
                       // alert ($("#"+target_id).children.length);
                       // alert (target_id);
                       mask_target_id=$("#"+target_id).children().first().attr('id');
                       // alert (target_id);

                   }
                }
                a_end[key] = val;
            });
        } else {
            a_end[property] = end;
        }
        a_duration[property] = duration;
        a_curve[property] = curve;
        a_property[property] = property;
        a_finished[property] = finished;
//popmotion
        const {easing, tween, styler} = window.popmotion;

        if (typeof mask_target_id != "undefined") {
        // if(mask_target_id){
            const mask_divStyler = styler(document.querySelector('#' + mask_target_id));
            a_mask_start= {background: a_start.background};
            a_mask__end= {background: a_end.background};
            tween({
                from: a_mask_start,
                to: a_mask__end,
                duration: duration,
                ease: easing[curve],
                flip: loop,
                yoyo: yoyo
            })
                .start(mask_divStyler.set);
        }
        delete(a_start.background);
        delete(a_end.background);

            const divStyler = styler(document.querySelector('#' + target_id));
            tween({
                from: a_start,
                to: a_end,
                duration: duration,
                ease: easing[curve],
                flip: loop,
                yoyo: yoyo
            })
                .start(divStyler.set);

    },
};