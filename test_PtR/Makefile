test:
	${TRINITY_HOME}/Analysis/DifferentialExpression/PtR -m candidate.Trinity_trans.TMM.EXPR.matrix -s candidate.samples.txt --log2 --heatmap --heatmap_colorscheme 'black,yellow'
	${TRINITY_HOME}/Analysis/DifferentialExpression/PtR -m candidate.Trinity_trans.counts.matrix -s candidate.samples.txt --log2 --CPM --sample_cor_matrix
	${TRINITY_HOME}/Analysis/DifferentialExpression/PtR -m candidate.Trinity_trans.counts.matrix -s candidate.samples.txt --log2 --CPM --prin_comp 3 --add_prin_comp_heatmaps 5 --Zscale
	${TRINITY_HOME}/Analysis/DifferentialExpression/PtR -m candidate.Trinity_trans.counts.matrix --log2 --CPM -s candidate.samples.txt --compare_replicates
	${TRINITY_HOME}/Analysis/DifferentialExpression/PtR -m candidate.Trinity_trans.TMM.EXPR.matrix -s candidate.samples.txt --log2 --imgfmt svg --boxplot_log2_dist 0.8
	${TRINITY_HOME}/Analysis/DifferentialExpression/PtR -m candidate.Trinity_trans.TMM.EXPR.matrix -s candidate.samples.txt --log2 --top_variable_genes 300 --min_across_ANY_samples_gene_expr_val 5 --gene_cor_matrix
	${TRINITY_HOME}/Analysis/DifferentialExpression/PtR -m candidate.Trinity_trans.TMM.EXPR.matrix -s candidate.samples.txt --log2 --mean_vs_sd
#	head -n11 candidate.Trinity_trans.TMM.EXPR.matrix > test.matrix && ${TRINITY_HOME}/Analysis/DifferentialExpression/PtR -m test.matrix -s candidate.samples.txt --per_gene_plots --per_gene_plots_incl_vioplot

	${TRINITY_HOME}/Analysis/DifferentialExpression/PtR -m candidate.Trinity_trans.TMM.EXPR.matrix -s candidate.samples.txt --log2 --heatmap --heatmap_colorscheme 'black,yellow' --order_columns_by_samples_file

	touch ./test


clean:
	rm -f ./candidate.Trinity_trans.TMM.EXPR.matrix.*
	rm -f ./test
	rm -f ./test.matrix ./test.matrix.*
	rm -f ./*.pdf
	rm -f ./*.svg
