"use client"

import { Navbar } from "@/components/navbar"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { motion } from "framer-motion"
import Link from "next/link"
import {
  Zap,
  Workflow,
  Shield,
  BarChart3,
  Users,
  Clock,
  Check,
  ArrowRight,
} from "lucide-react"

const features = [
  {
    icon: Workflow,
    title: "Visual Worker Builder",
    description: "Drag-and-drop interface to create automation workflows without code",
  },
  {
    icon: Users,
    title: "Department Management",
    description: "Organize workers by departments for better team collaboration",
  },
  {
    icon: BarChart3,
    title: "Real-time Analytics",
    description: "Track execution stats, performance metrics, and ROI insights",
  },
  {
    icon: Shield,
    title: "Enterprise Security",
    description: "Bank-level encryption and compliance with SOC2, GDPR standards",
  },
  {
    icon: Clock,
    title: "24/7 Automation",
    description: "Workers run continuously to handle tasks around the clock",
  },
  {
    icon: Zap,
    title: "Lightning Fast",
    description: "Execute thousands of workflows per minute with high reliability",
  },
]

const plans = [
  {
    name: "Free",
    price: "$0",
    description: "Perfect for trying out WorkForce AI",
    features: [
      "5 active workers",
      "1,000 executions/month",
      "Basic templates",
      "Community support",
    ],
  },
  {
    name: "Pro",
    price: "$49",
    description: "For growing teams and businesses",
    features: [
      "Unlimited workers",
      "50,000 executions/month",
      "All templates",
      "Priority support",
      "Advanced analytics",
      "Custom integrations",
    ],
    popular: true,
  },
  {
    name: "Enterprise",
    price: "Custom",
    description: "For large organizations",
    features: [
      "Everything in Pro",
      "Unlimited executions",
      "Dedicated support",
      "SLA guarantees",
      "Custom deployment",
      "White-label option",
    ],
  },
]

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-background">
      <Navbar />

      {/* Hero Section */}
      <section className="container mx-auto px-4 py-20 md:py-32">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="text-center"
        >
          <h1 className="text-5xl md:text-7xl font-bold tracking-tight mb-6">
            Build Your
            <span className="text-primary"> AI Workforce</span>
          </h1>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto mb-8">
            Automate your company processes with intelligent workers. No code required.
            Deploy in minutes, scale to thousands.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link href="/try">
              <Button size="lg" className="text-lg px-8">
                Try Now - Free <ArrowRight className="ml-2 h-5 w-5" />
              </Button>
            </Link>
            <Link href="/dashboard">
              <Button size="lg" variant="outline" className="text-lg px-8">
                View Dashboard
              </Button>
            </Link>
          </div>

          <div className="mt-16 rounded-lg border border-border bg-card/50 p-2 shadow-2xl">
            <div className="aspect-video rounded bg-muted flex items-center justify-center">
              <div className="text-center">
                <Workflow className="h-24 w-24 text-primary mx-auto mb-4" />
                <p className="text-muted-foreground">Visual Worker Builder Preview</p>
              </div>
            </div>
          </div>
        </motion.div>
      </section>

      {/* Features Section */}
      <section id="features" className="container mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold mb-4">Powerful Features</h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Everything you need to automate your business processes
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <motion.div
              key={feature.title}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              viewport={{ once: true }}
            >
              <Card className="h-full hover:border-primary/50 transition-colors">
                <CardHeader>
                  <div className="rounded-lg bg-primary/10 w-12 h-12 flex items-center justify-center mb-4">
                    <feature.icon className="h-6 w-6 text-primary" />
                  </div>
                  <CardTitle>{feature.title}</CardTitle>
                  <CardDescription>{feature.description}</CardDescription>
                </CardHeader>
              </Card>
            </motion.div>
          ))}
        </div>
      </section>

      {/* Pricing Section */}
      <section id="pricing" className="container mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold mb-4">Simple Pricing</h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Choose the plan that fits your needs
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-8 max-w-6xl mx-auto">
          {plans.map((plan, index) => (
            <motion.div
              key={plan.name}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              viewport={{ once: true }}
            >
              <Card className={`h-full ${plan.popular ? 'border-primary shadow-lg' : ''}`}>
                <CardHeader>
                  {plan.popular && (
                    <div className="bg-primary text-primary-foreground text-xs font-semibold px-3 py-1 rounded-full w-fit mb-2">
                      Most Popular
                    </div>
                  )}
                  <CardTitle className="text-2xl">{plan.name}</CardTitle>
                  <div className="mt-4">
                    <span className="text-4xl font-bold">{plan.price}</span>
                    {plan.price !== "Custom" && <span className="text-muted-foreground">/month</span>}
                  </div>
                  <CardDescription>{plan.description}</CardDescription>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-3">
                    {plan.features.map((feature) => (
                      <li key={feature} className="flex items-center gap-2">
                        <Check className="h-5 w-5 text-primary flex-shrink-0" />
                        <span className="text-sm">{feature}</span>
                      </li>
                    ))}
                  </ul>
                  <Link href="/try">
                    <Button
                      className="w-full mt-6"
                      variant={plan.popular ? "default" : "outline"}
                    >
                      Get Started
                    </Button>
                  </Link>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>
      </section>

      {/* CTA Section */}
      <section className="container mx-auto px-4 py-20">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          viewport={{ once: true }}
          className="bg-primary rounded-2xl p-12 text-center"
        >
          <h2 className="text-4xl font-bold text-primary-foreground mb-4">
            Ready to automate your workflow?
          </h2>
          <p className="text-xl text-primary-foreground/90 mb-8 max-w-2xl mx-auto">
            Join thousands of companies using WorkForce AI to streamline their operations
          </p>
          <Link href="/try">
            <Button size="lg" variant="secondary" className="text-lg px-8">
              Start Building Workers Now
            </Button>
          </Link>
        </motion.div>
      </section>

      {/* Footer */}
      <footer className="border-t border-border py-12">
        <div className="container mx-auto px-4">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <div className="flex items-center space-x-2 mb-4 md:mb-0">
              <div className="rounded-lg bg-primary p-2">
                <Zap className="h-5 w-5 text-primary-foreground" />
              </div>
              <span className="text-lg font-bold">WorkForce AI</span>
            </div>
            <p className="text-sm text-muted-foreground">
              2024 WorkForce AI. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    </div>
  )
}
