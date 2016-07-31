# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

# BONUS PROBLEM: requires sub-queries or joins. Attempt this after completing
# sections 04 and 07.

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
    SELECT
      physics_count.yr
    FROM
      (SELECT
        yr, COUNT(*) AS physics_prizes
      FROM
        nobels
      WHERE
        subject = 'Physics'
      GROUP BY
        yr) AS physics_count
      LEFT OUTER JOIN
        (SELECT
          yr, COUNT(*) as chemistry_prizes
        FROM
          nobels
        WHERE
          subject = 'Chemistry'
        GROUP BY
          yr) AS chemistry_count
      ON
        physics_count.yr = chemistry_count.yr
      WHERE
        physics_count.physics_prizes > 0 AND
        (chemistry_count.chemistry_prizes IS NULL OR
          chemistry_count.chemistry_prizes = 0)
  SQL
end
