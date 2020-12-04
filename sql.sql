SELECT
            sc.*,
            str.complaintRelStr
        FROM
            sys_complaint AS sc
        LEFT JOIN (
            SELECT
                DISTINCT
                    scr1.complaint_id,
                    GROUP_CONCAT(DISTINCT sd.`name`) AS complaintRelStr
                FROM
                    sys_complaint_rel scr1
                LEFT JOIN sys_dic AS sd on scr1.`code` = sd.`code`
            <if test="ew.code != null and ew.code.size != 0">
                LEFT JOIN (
                    SELECT
                      complaint_id
                    FROM
                      sys_complaint_rel AS scr
                    WHERE
                      scr.`code` IN
                <foreach  item="item" collection="ew.code" index="index"  open="(" separator="," close=")">#{item}</foreach>
                    GROUP BY
                    `complaint_id`
                    HAVING
                     COUNT( `complaint_id` ) = ${ew.code.size}
                ) AS rel ON rel.complaint_id = scr1.complaint_id
                WHERE
                    rel.complaint_id IS NOT NULL
            </if>
            GROUP BY
                scr1.complaint_id
        ) AS str ON sc.id = str.complaint_id
        WHERE
            str.complaintRelStr IS NOT NULL
        AND sc.mark = 1
        <if test="ew.mobile != null and ew.mobile !=''">
            AND sc.mobile = #{ew.mobile}
        </if>
        <if test="ew.complaintTimeFrom != null and ew.complaintTimeFrom !='' and ew.complaintTimeTo != null and ew.complaintTimeTo !=''">
            AND sc.create_time BETWEEN #{ew.complaintTimeFrom} AND #{ew.complaintTimeTo}
        </if>
        ORDER BY sc.id DESC