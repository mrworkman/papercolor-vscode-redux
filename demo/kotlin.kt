package com.r3.dr.test.gen.flows

import co.paralleluniverse.fibers.Suspendable
import com.r3.corda.lib.tokens.contracts.utilities.heldBy
import com.r3.corda.lib.tokens.contracts.utilities.issuedBy
import com.r3.corda.lib.tokens.contracts.utilities.of
import com.r3.corda.lib.tokens.money.GBP
import com.r3.corda.lib.tokens.workflows.flows.issue.IssueTokensFlow
import net.corda.core.flows.FinalityFlow
import net.corda.core.flows.FlowLogic
import net.corda.core.flows.InitiatingFlow
import net.corda.core.flows.StartableByRPC
import net.corda.core.utilities.ProgressTracker
import net.corda.core.utilities.ProgressTracker.Step
import java.time.Duration
import java.time.Instant

@InitiatingFlow
@StartableByRPC
class GenerateIssuances(
    val count: Int,
    val commitAfter: Int = 2000
): FlowLogic<Unit>() {

    // This flow is restartable. It checks how many issuances already exist, and stops when the total in the vault is
    // met, or exceeded.

    @Suspendable
    @Suppress("JpaQlInspection")
    override fun call() {

        logger.error("Getting number of existing issuances...")

        // Get the number of existing issuances
        val existingIssuancesCount = serviceHub.withEntityManager {
            createQuery("SELECT COUNT(TRANSACTION_ID) FROM VaultSchemaV1\$VaultFungibleStates")
                .resultList.single() as Long
        }.toInt()

        logger.error("$existingIssuancesCount issuances found.")

        val startTime = Instant.now()

        updateProgress(0, 0, existingIssuancesCount, startTime)

        var difference = count - existingIssuancesCount
        var prevPercentage = 0

        if (difference > 0) {
            (1..difference).forEach {
                val percentageRounded = ((it / difference.toDouble()) * 10).toInt() * 10

                // Create an issuance
                subFlow(IssueTokensFlow(listOf(1 of GBP issuedBy ourIdentity heldBy ourIdentity), emptyList()))

                if (prevPercentage != percentageRounded) {
                    updateProgress(percentageRounded, it, it + existingIssuancesCount, startTime)

                    // Commit for every 10%.
                    sleep(Duration.ofMillis(1))
                } else {
                    // Commit every X transactions.
                    if (it != 0 && it % commitAfter == 0) {
                        sleep(Duration.ofMillis(1))
                    }
                }

                prevPercentage = percentageRounded
            }
        } else {
            updateProgress(100, 0, existingIssuancesCount, startTime)
        }
    }

    @Suspendable
    private fun updateProgress(percentage: Int, count: Int, existing: Int, startTime: Instant) {
        // Using error will make it print to the console as well.
        logger.error(
            "Issuance generation @ $percentage% ($count txes of $existing total) after ${Duration.between(startTime, Instant.now())}."
        )
    }
}